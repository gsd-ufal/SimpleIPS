function listcontainers()
	readdir("containers")	
end


"Starts a container with the specified resources on the model [memory (MB), cpus]. 
The defautl values for memory and CPU is 512MB and 2 cores
"
function deploycontainer(resources=[512,2],authkey=0)
	infra_id = 1

	temp_contname = string(randstring(10)) 
	#It will be rand for a  while. The name will be changed after the container creation
	memory = string("-m=",resources[1],"MB")
	cpus = string("--cpus=",resources[2])

	
	run(pipeline(`docker run -itd $memory $cpus  naelsondouglas/julia`, string(temp_contname)))
	f = open(temp_contname)
	container_name = string("containers/",chomp(readlines(f)[1]))
	mv(temp_contname,container_name )
	

	return infra_id #this return is currently not implemented. The code is returning always the number 1. 
end

"Deletes a Docker container given it's ID"
function deletecontainer(id::String)
	@async run(`docker rm -f $id`)
	rm("containers/$id")
end

"Delete all containers created by the application --- Containers created outside the application are not affected"
function deleteall_containers()
	containers = readdir("containers")
	for cont in containers
		deletecontainer(cont)
	end
	println("")
end

#It will send the IPS a message confirming the loaddataset function worked
function senddatasetsstatus(loadconfirmation)
	return "data_sets_status"
end

function execute(runtime_conf, infra_id, kernel, input_dataset::String, subset)
	#it will apply the proccess() call itself on the compute service and then return the output

	return output
end

function stopinfra(infra_id::String)
	
end
