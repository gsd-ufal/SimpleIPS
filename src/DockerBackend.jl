function listcontainers()
	readdir("containers")
end

"Starts a container with the specified resources on the model [memory (MB), cpus].
The defautl values for memory and CPU is 512MB and 1 core.
"
function run_container(res_requirements=[512,1])
	temp_cont_filename = string(randstring(10)) #	temp_dir = mktempdir(pwd())
	#It will be rand for a  while. The name will be changed after the container creation
	memory = string("-m=",res_requirements[1],"MB")
	cpus = string("--cpus=",res_requirements[2])
	dockerhub_image=string("naelsondouglas/julia")

	println("Running docker image $dockerhub_image")
	try
		run(pipeline(`docker run -itd $memory $cpus $dockerhub_image`, string(temp_cont_filename)))
	catch
		error("Container NOT deployed: could not execute 'docker run' command!")
		return false
	end

	f = open(temp_cont_filename)
	container_id = string("containers/",chomp(readlines(f)[1]))
	mv(temp_cont_filename,container_id)

	println("Container $container_id is up")
	return true
end

"Deletes a Docker container given it's ID. This function froces a container to stop."
function deletecontainer(id::String)
	try
		println("Deleting container $id")
		run(`docker rm -f $id`)
		rm("containers/$id")
		println("Container $id deleted.")
	catch
		error("Could NOT delete container $id")
		return false
	end
	return true
end

"Delete all containers created by the application --- Containers created outside the application are not affected"
function deleteall_containers()
	println("Deleting all containers")
	containers = readdir("containers")
	for cont in containers
		@async deletecontainer(cont)
	end
end

#It will send the IPS a message confirming the loaddataset function worked
function senddatasetsstatus(loadconfirmation)
	return "data_sets_status"
end
