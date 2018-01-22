function deployinfraserver(IPS_auth, resources)
	infra_id = 1
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