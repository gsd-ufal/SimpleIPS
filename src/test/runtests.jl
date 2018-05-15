include("../DockerBackend.jl")
include("../Infrastructure.jl")
include("../Storage.jl")
include("../RSProcessingService.jl")

propose_sla(1,1,1)

function test_infra()
	run_container(translate_qos(1))
	deleteall_containers()

	println(get_slas())
end


function test_docker_backend()
	deploy_infra(1,["512","1"])
	deploy_infra(1,["512","1"])
	listcontainers()
	deleteall_containers()
	deleteall_containers() # should print info
	deletecontainer("-1") # should print error
	println(execute_code("-E println(sqrt(144));1+13"))
end

function test_storage()
	get_dataset_metadata()
	for sla in get_slas()
		info(sla)
	end
end

function test_rsps()
	get_dataset_metadata()
	get_slas()
	propose_sla(1,1,1)
	process(1,"code")
	finish(1)
end

function todo()

end

function todo()

end
