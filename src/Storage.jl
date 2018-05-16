
"
Get the metada from available data sets.
Return `-1` if not sucessfull.
"
function get_available_metadata(rsps_storage_authkey)
	#TODO code
	return [["maceio", "optical", "landsat", "5000x8000", "5gb", "2012-03-29"],
		    ["maceio", "polsar", "landsat", "15000x10000", "3gb", "2012-10-31"],
			["maceio", "lidar", "gedi", "3000x9000", "8gb", "2019-01-01"]]  #TODO return -1 in case of erro
end

"
Copy the data set from to previously deployed infrastructure whose ID is `infra_id`,
Return `-1` if not successful.
"
function transfer_datasets(rsps_storage_authkey,dataset)
	#TODO code: copy the data to the running container
	return 0 #TODO Return `-1` if not successful.
end
