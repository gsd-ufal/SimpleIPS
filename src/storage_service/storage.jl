include("../infra_service/infrastructure.jl")

"""
Get the metada from available data sets.
Return `-1` if not sucessfull.
"""
function get_available_metadata(ips_storage_authkey)
	#TODO code
	return 1 #TODO return -1 in case of error
end


"""
Get the data set from the storage and load it at the
Return the `infra_session_id`
"""
function load_datasets(infra_id,dataset)
	transfer_dataset(infra_id,dataset) #TODO error treatment
	return 1 #TODO return a unique ID
end
