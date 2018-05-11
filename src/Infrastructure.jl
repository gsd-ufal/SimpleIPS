module Infrastrcture

export deploy_infra, execute, undeploy_infra

include("DockerBackend.jl")

"""
Deploy infrastructure with `res_requirements` configuration.
Return the `infra_session_id`
"""
function deploy_infra(auth_key,res_requirements)
	#TODO auth_key
	run_container(res_requirements)
	return 1 #TODO return a unique ID
end
#deploy_infra(1,["512","1"])
#deleteall_containers()

"""
Executes the following command:
```bash
docker run -m mem --cpus cpus image runtime_conf
```
Remark: Optional arguments is not supported currently.
"""
function execute(infra_id, runtime_conf, kernel="none", input_dataset::String="none", subset="none")
	#it will apply the process() call itself on the compute service and then return the output

	return output=1

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
#deploy_infra(1,["512","1"])
#deleteall_containers()Get the metada from available data sets.
Return false if not sucessfull.
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
Copy the data set from to previously deployed infrastructure whose ID is `infra_id`,
Return `false` if not successful.
"""
function transfer_dataset(infra_id,dataset)
	#TODO code: copy the data to the running container
	return true
end

end #Module
