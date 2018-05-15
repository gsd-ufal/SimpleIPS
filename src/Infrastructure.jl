
"""
Deploy infrastructure with `res_requirements` configuration.
Return the `infra_session_id`
"""
function deploy_infra(auth_key,res_requirements)
	#TODO auth_key mgmt
	run_container(auth_key,res_requirements)
	return 1 #TODO return a unique ID
end

"""
Request to backend to execute the `code`.
Remark: Optional arguments are not supported currently.
"""
function execute(infra_id, code, kernel="none", input_dataset::String="none", subset="none")
	#TODO infra_id
	return execute_code(code)
end

"""
Destroy all deployed infrastructure.
Returns -1 if not sucessful.
"""
function undeploy_infra(infra_id::String)
	#TODO
	return 1
end



#
# NON-EXPORTED FUNCTIONS
#

"""
#TODO doc
Return `-1` if not sucessfull.
"""
function get_datasets_metadata()
	return 1 #TODO return a unique ID or -1 in case of error
end

"""
Get the available SLA types. SLA here is simplified to
Returns the `ips_session_id` or -1 if not sucessfull.

Disclaimer: The **cost is an estimation** on how much would be payed to public
Clouds for Docker instances with these requirements.
"""
function get_slas()
	return ["SLA 1: 512MB, 1 vCPU, USD 0.057/hour",
					"SLA 2: 1024MB, 2 vCPUs, USD 0.114/hour",
					"SLA 3: 2048MB, 4 vCPUs, USD 0.228/hour"]
	#TODO return false in case of error
end

"""
Authenticate the client at Infra Service.
Returns the `ips_session_id` or -1 if not sucessfull.
"""
function authenticate(auth_key)
	return 1 #TODO return a unique ID or -1 in case of error
end

"""
Maps high-level QoS parameters to resource-level configuration.
Avaialables SLA are 1, 2, and 3. The higher the value, the more computing
resources it requires.
Return the `res_requirements[mem,cpus]` vector or `false` if not sucessfull.
"""
function translate_qos(sla::Int)
	res_requirements=[0,0]

	if sla < 1 || sla > 3
		error("SLA $sla NOT supported.")
		return false
	elseif sla == 1
		res_requirements[1] = 512
		res_requirements[2] = 1
	elseif sla == 2
		res_requirements[1] = 1024
		res_requirements[2] = 2
	elseif sla == 3
		res_requirements[1] = 2048
		res_requirements[2] = 4
	end

	return res_requirements
end

"""
Get the data set from the storage and load it at the
Return the `infra_session_id`
"""
function load_datasets(infra_id,rsps_storage_authkey,dataset)
	data = transfer_datasets(rsps_storage_authkey,dataset) #TODO error treatment
	#TODO store data in Container memory
	return 1 #TODO return a unique ID
end
