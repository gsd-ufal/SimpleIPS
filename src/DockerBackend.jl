#dockerhub_image = string("naelsondouglas/julia")
dockerhub_image = string("hello-world")
listof_containers = Dict()

"Executes the command `docker pull $img`"
function pullimage(img="hello-world")
	try
		run(`docker pull $img`)
	catch
		error("Could NOT pull Docker image `$img`. Check Internet connection. System will quit now.")
		exit(1)
	end
end

"Return the list of containers owned by client whose authentication key is `key`"
function containers(key)
	return listof_containers[key]
end

"
Add the `container_id` to the `listof_containers` at key `key`.
TODO persistency to FS: move from run_container to here
"
function add_container_userkey(key,container_id::String)
	if !haskey(listof_containers,key)
		println("AQUI")
		@show listof_containers
		global listof_containers[key] = ["temp"]
		@show listof_containers
		global listof_containers[key][1] = container_id
		@show listof_containers
	else
		global listof_containers[key] = vcat(listof_containers[key],container_id)
	end
end
# v = ["a"]
# @show v

"
Run a container with the specified resources [memory (MB), cpus].
The defautl values for memory and CPU is 512MB and 1 core.
Return the `container_id` or `-1 ` if not sucessful.
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
		return -1
	end
	info("Output from docker `run -itd $memory $cpus $dockerhub_image` command was stored at $temp_cont_filename_string")
	f = open(temp_cont_filename_string)
	container_id =readlines(f)[1]
	info("Container ID is $container_id")
	add_container_userkey(auth_key,container_id)

	#container_id_path = string("containers/",chomp(container_id))
	#mv(temp_cont_filename,container_id_path)
	rm(temp_cont_filename, force=true)
	info("Container $container_id is up")
	return container_id
end

"
Remove a Docker container by Docker container ID.
This function froces a container to stop.
Return `false` if not successful.
"
function rmcontainer(key,id::String)
	filename = "docker_output.tmp"
	try
		info("Removing container $id")
		run(pipeline(`docker rm -f $id`, filename)) #, append=true))
	catch
		error("Container NOT delete container $id: could not execute 'docker rm' command. See $filename")
		return false
	end
	index = findfirst(listof_containers[key],id)

	@show listof_containers[key]
	@show id
	@show index
	@show typeof(listof_containers[key])

	global listof_containers[key] = splice!(listof_containers[key], index)

	info("Container $id removed.")
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
Return `false` if not sucessfull.
"""
function execute_code(code)
	filename = "docker_output.tmp"
	juliabin = "/opt/julia-0.6.2/bin/julia"
	try
		run(pipeline(`docker exec $container_id $juliabin $code`, filename)) #, append=true))
	catch
		error("Could NOT `docker exec` code on Docker container $container_id. See $filename")
		return false
	end
	return readlines(filename)
end

#TODO-Naelson fix add/remove container_id at listof_containers
function test_docker_backend()

	cid = run_container(1,["512","2"])
	@show listof_containers
	rmcontainer(1,cid)

	rmcontainer(1,"2e9bd94aa76457a0ec14788def15797e06626661f75c58106af1c66261c97326")
	@show listof_containers
	cid

	@show
	index = findfirst(listof_containers[1],cid)
	@show index
	splice!(listof_containers[1], index)


	@show length(listof_containers[1][2])
	@show listof_containers[1]



	global listof_containers[key] = splice!(listof_containers[key], index)





	run_container(1)
	@show containers(1)
	@show containers(2)
	run_container(2)
	@show listof_containers



	# deleteall_containers()
	# deleteall_containers() # should print info
	# deletecontainer("-1") # should print error
	# println(execute_code("-E println(sqrt(144));1+13"))
end
