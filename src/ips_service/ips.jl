include("ips_internals.jl")

"""
Get the metada from available data sets.
Return false if not sucessfull.
"""
function get_datasets_metadata()
	return 1 #TODO return a unique ID or -1 in case of error
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
`auth_key`
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

	


end
propose_sla(3)




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

#
# TESTS
#

function test()

end
