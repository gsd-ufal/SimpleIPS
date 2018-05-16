dockerhub_image = string("naelsondouglas/julia")
listof_containers = Dict()

try
	#run(`docker pull $dockerhub_image`) #TODO uncomment it
catch
	error("Could NOT pull Docker image `$dockerhub_image`. Check Internet connection. System will quit now.")
	exit(1)
end

#TODO redo it by using listof_containers
function listcontainers()
	readdir("containers")
end

function add_container_userkey(key,container_id)
	global listof_containers[key] = vcat(listof_containers[key],container_id)
	#TODO persistency to FS
end

"
Starts a container with the specified resources on the model [memory (MB), cpus].
The defautl values for memory and CPU is 512MB and 1 core.
TODO Return ....
"
function run_container(auth_key,res_requirements=[512,1])
	temp_cont_filename = string(randstring(10)) #	temp_dir = mktempdir(pwd())
	#It will be rand for a  while. The name will be changed after the container creation
	memory = string("-m=",res_requirements[1],"MB")
	cpus = string("--cpus=",res_requirements[2])

	info("Running docker image $dockerhub_image")
	temp_cont_filename_string = string(temp_cont_filename)
	try
		run(pipeline(`docker run -itd $memory $cpus $dockerhub_image`, temp_cont_filename_string))
	catch
		error("Container NOT deployed: could not execute 'docker run' command!")
		return false
	end
	info("output from docker `run -itd $memory $cpus $dockerhub_image` command was stored at $temp_cont_filename_string")
	f = open(temp_cont_filename_string)
	container_id =readlines(f)[1]
	info("Container ID is $container_id")
	push!(listof_containers, [auth_key,container_id])
	@show listof_containers

	container_id_path = string("containers/",chomp(container_id))
	mv(temp_cont_filename,container_id_path)
	println("Container $container_id is up")
	return true
end

"
Delete a Docker container by Docker container ID.
This function froces a container to stop.
Return `false` if not successful.
"
function deletecontainer(id::String)
	try
		info("Deleting container $id")
UNDO		#run(`docker rm -f $id`)
UNDO 	#	rm("containers/$id")
		info("Container $id deleted.")
	catch
		error("Could NOT delete container $id")
		return false
	end
	return true
end

"
Delete all Docker containers deployed by `auth_key`.
This function froces a container to stop.
Return `false` if not successful.
"
function deletecontainers(auth_key::Int)
#	try
		for c in listof_containers
			if c[1] == auth_key
				info("Asking to delete container whose auth_key is $auth_key:  $c[2]")
				deletecontainer(c[2])
				#TODO PAREI AQUI tetnar remover da listof_containers
				deleteat!(listof_containers,getindex(listof_containers,c))
			end
		end
# UNDO	catch
#		error("Could NOT delete container whose auth_key is $auth_key")
#		return false
#	end
	return true
end
deletecontainers(1)

"
Delete all containers created by DockerBackend.
Returns `-1` if there is no container running and does not call
`docker rm` command.
"
function deleteall_containers()
	println("Deleting all containers")
	containers = readdir("containers")
	if containers == [] ||
		(length(containers) == 1 && containers[1] == ".DS_Store") # ignore .DS_Store MacOS dir
		warn("deleteall_containers(): there is no container running.")
		return -1
	end
	for cont in containers
		if ! (cont == ".DS_Store") # ignore .DS_Store MacOS dir
			@async deletecontainer(cont)
		end
	end
end

#It will send the IPS a message confirming the loaddataset function worked
function senddatasetsstatus(loadconfirmation)
	return "data_sets_status"
end

"""
Execute the `code` on the previsouly deployed Docker container.
Return -1 if not sucessfull.
"""
function execute_code(code)
	try
		run(pipeline(`docker exec $container_id /opt/julia-0.6.2/bin/julia $code`, "docker.out"))
	catch
		error("Could NOT execute code on Docker container $container_id.")
		exit(1)
	end
	return readlines("docker.out")
end
