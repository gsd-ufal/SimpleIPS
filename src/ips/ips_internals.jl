include("compute_service.jl")

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
Deploy infrastructure with `res_requirements` configuration.
Return the `infra_session_id`
"""
function deploy_infra(auth_key,res_requirements)
	deploycontainer()
	return 1 #TODO return a unique ID
end

"""
Executes the following command:
```bash
docker run -m mem --cpus cpus image runtime_conf
```
Remark: Optional arguments is not supported currently.
"""
function execute(infra_id, runtime_conf, kernel="none", input_dataset::String="none", subset="none")
	#it will apply the proccess() call itself on the compute service and then return the output

	return output
end

function undeploy_infra(infra_id::String)
	#TODO
end


#
# TESTS
#

function test()

	run_container(translate_qos(1))
	deleteall_containers()

	println(get_slas())

end
