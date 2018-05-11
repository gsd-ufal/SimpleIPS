module RSProcessingService
using Infrastrcture
export get_dataset_metadata, get_slas, propose_sla, process, finish

ips_storage_authkey=1

"""
Get the metada from available data sets.
"""
function get_dataset_metadata()
	return get_available_metadata(ips_storage_authkey) #from ../storage_service/storage.jl
end

"""
Get the available SLA types. SLA is simplified to resource requierements
and its costs.

Disclaimer: The **cost is an estimation** on how much would be payed to public
Clouds for Docker instances with these requirements.
"""
function get_slas()
	return ["SLA 1:  512MB, 1 vCPU,  USD 0.057/hour",
			"SLA 2: 1024MB, 2 vCPUs, USD 0.114/hour",
			"SLA 3: 2048MB, 4 vCPUs, USD 0.228/hour"]
end

"""
Propose an `sla` for using in a given `dataset`.
Return the `session_id` or `-1` if not successful.
"""
function propose_sla(auth_key,sla,dataset)
	auth = authenticate(auth_key)
	if auth == -1
		error("Authentication failed: $auth")
		return -1
	end

	res_requirements = translate_qos(sla)
	if res_requirements == -1
		error("QoS translation failed: $res_requirements")
		return -1
	end

	infra_id = deploy_infra(auth_key,res_requirements)
	if infra_id == -1
		error("Infra deployment failed: ID is $infra_id")
		return -1
	end

	dataset_status = load_datasets(infra_id,dataset)
	if dataset_status == -1
		error("Infra deployment failed: ID is $dataset_status")
		return -1
	end

	#TODO code
end

"""
Propose an `sla` for using in a given `dataset`.
Return the `session_id` or `-1` if not successful.
"""
function process(session_id, code)
	#TODO code
	return -1
end

"""
Terminate service provisioning by undeploying the infrastrcture and calculating
returning the bill to the client.
Return `-1` if not successful.
"""
function finish(session_id, history_data=true)
	#TODO code
	return -1
end


#
# NON-EXPORTED FUNCTIONS
#

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
Return the `res_requirements[mem,cpus]` vector or `-1` if not sucessfull.
"""
function translate_qos(sla::Int)
	res_requirements=[0,0]

	if sla < 1 || sla > 3
		error("SLA $sla NOT supported.")
		return -1
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
Initiate billing accounting in a pay-as-you-go fashion.
Returns -1 if not sucessfully initiated.

Disclaimer: acounting **only serves as means to estimate** the costs on public
Cloud infrastructure usage.
"""
function start_billing(session_id)
	#TODO tic and save it
	return 1 #TODO return-1 in case of error
end

"""
TODO I think this function is not necessary anymore.
"""
function config_execution(session_id)
	#TODO code
	return 1 #TODO return-1 in case of error
end

"""
Saves historical data of a code execution.
Returns -1 if not sucessful.
"""
function history(session_id, code)
	#TODO code
	return 1 #TODO return-1 in case of error
end


"""
Initiate billing accounting in a pay-as-you-go fashion.
Returns -1 if not sucessfully initiated.

Disclaimer: acounting **only serves as means to estimate** the costs on public
Cloud infrastructure usage.
"""
function stop_billing(session_id)
	#TODO toc and save it
	#TODO calculate the bill based on the SLA and time (translate SLA and calculate)
	return 1 #TODO return-1 in case of error
end

end #Module
