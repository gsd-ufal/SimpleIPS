rsps_storage_authkey=1
initial_billing_time=-1
end_billing_time=-1
SLA = -1
"List of clients (`authkey`) and their respective sessions IDs"
listof_clients = Dict()

"""
Get the metada from available data sets.
"""
function get_dataset_metadata()
	return get_available_metadata(rsps_storage_authkey) #from Storage.jl
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

"
Create a unique client authentication key `authkey` (ID) which enables clients
to access the service.
Return the just-created `authkey`.
"
function generate_authkey()
	#TODO sync
	#TODO enable third-party authentication
	@show newauthkey = abs(rand(Int))
	#while contains(==,listof_clients,newauthkey)
	while haskey(listof_clients,newauthkey)
		newauthkey = rand(Int)
	end
	info("New client auth key $newauthkey generated and will be added to list of clients")
	#push!(listof_clients,newauthkey)
	global listof_clients[newauthkey] = []
	@show listof_clients[newauthkey]
	return newauthkey
end
generate_authkey()
"
Propose an `sla` for using in a given `dataset`. Avaialable SLAs are:

* 1: 512MB, 1 vCPU,  USD 0.057/hour
* 2: 1024MB, 2 vCPUs, USD 0.114/hour
* 3: 2048MB, 4 vCPUs, USD 0.228/hour

SLA should be choosen indicating on of the aforementined IDs (`Int` type).
Optionally, you can directly indicate the resource requirements if `sla` is
indicated by `Array{Int}`, e.g., `[512,1]` represents 512MB and 1 vCPU.

Return the `session_id` or `-1` if not successful.
"
function propose_sla(auth_key,sla,dataset)
	session_id = authenticate(auth_key)
	if session_id == -1
		error("Authentication failed: $session_id")
		return -1
	end
	println(typeof(sla))
	if typeof(sla) == Array{Int} #TODO not working
		res_requirements[1] = sla[1]
		res_requirements[2] = sla[2]
	elseif typeof(sla) == Int
		res_requirements = translate_qos(sla)
		if res_requirements == -1
			error("QoS translation failed: $res_requirements")
			return -1
		end
	else
		error("Bad `sla` type: $typeof(sla)")
		return -1
	end

	infra_id = deploy_infra(auth_key,res_requirements)
	if infra_id == -1
		error("Infra deployment failed: ID is $infra_id")
		return -1
	end

	dataset_status = load_datasets(infra_id,rsps_storage_authkey,dataset)
	if dataset_status == -1
		error("Data set loading failed: $dataset_status")
		return -1
	end

	billing_status = start_billing(session_id)
	if billing_status == -1
		error("Billing could not start: $billing_status")
		return -1
	end

	info("Proposed SLA $sla from client whose auth_key is $auth_key was
	accepted. Session ID is $session_id")
	global SLA = sla
	return session_id
end

"""
Process the `code`.
Return the code output or `-1` if not successful.
"""
function process(session_id, code)
	return execute(infra_id, code)
end

"""
Terminate service provisioning by undeploying the infrastrcture and calculating
returning the bill to the client.
Return `-1` if not successful.
"""
function finish(session_id, history_data=true)
	#TODO history_data

	return -1
end


#
# INTERNAL FUNCTIONS
#

"
Authenticate the client at Infra Service.
Returns the `rsps_session_id` or -1 if not sucessfull.
"
function authenticate(auth_key)
	if !haskey(listof_clients,auth_key)
		error("Client does NOT have an auth key. Call `generate_authkey` before
		calling this function.")
			return -1
	end
	return new_session(auth_key)
end

function new_session(auth_key)
	return 1 #TODO return a unique session_id (Dict: auth_key -> session_1, session_2, ..., session_N)
	global listof_containers[key] = vcat(listof_containers[key],container_id)
end



"""
Maps high-level QoS parameters to resource-level configuration.
Avaialables SLA are 1, 2, and 3. The higher the value, the more computing
resources it requires.
Return the `res_requirements[mem,cpus]` vector or `-1` if not sucessfull.
"""
function translate_qos(sla::Int)
	res_requirements=[0,0]
	@show sla
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
	# global tiq = tic() #TODO make time counting start here
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
	tic() #FIX create a proper time counting at start_billing
	sleep(1)
	bill = -1
	vCPU_per_sec = 0.00001406
	mem_1gb_per_sec = 0.00000353
	# try
		billing_time = toc()
		res_req = translate_qos(SLA)
		@show res_req
		bill = billing_time * vCPU_per_sec * res_req[2]
			 + billing_time * mem_1gb_per_sec * res_req[1]/1000
	 # catch
		 # error("Billing accounting failed!")
		 # return -1
	 # end
	return bill
end
