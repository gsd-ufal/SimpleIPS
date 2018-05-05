function deployinfraserver(IPS_auth=0, resources=[512])
	infra_id = 1

	temp_contname = string(randstring(10)) 
	#It will be rand for a  while. The name will be changed after the container creation
	memory = string("-m=",resources[1],"MB")

	println("Chegou aqui")
	run(pipeline(`docker run -itd $memory naelsondouglas/julia`, string(temp_contname)))
	print(temp_contname)
	f = open(temp_contname)
	container_name = string("containers/",chomp(readlines(f)[1]))
	mv(temp_contname,container_name )
	

	return infra_id
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
