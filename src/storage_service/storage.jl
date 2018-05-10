include("../infra/infra_service.jl")

"""
Get the data set from the storage and load it at the
Return the `infra_session_id`
"""
function dataset_status = load_datasets(infra_id,dataset)
	copy_dataset(infra_id,dataset) #TODO error treatment
	return 1 #TODO return a unique ID
end
