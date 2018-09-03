include("../DockerBackend.jl")
include("../Infrastructure.jl")
include("../Storage.jl")
include("../RSProcessingService.jl")

test_docker_backend()



info(get_dataset_metadata())
dataset = get_dataset_metadata()[1]

info(get_slas())
sla = 1

mykey = generate_authkey()
session_id = propose_sla(mykey,sla,dataset)
@show listof_containers

listcontainers(mykey)

run_container(mykey)
@show listof_clients
@show listof_clients
@show listof_containers
process
deleteall_containers()

function basic_usage()

end

function test_infra()
	run_container(translate_qos(1))
	deleteall_containers()

	println(get_slas())
end




function test_storage()
	get_dataset_metadata()
	for sla in get_slas()
		info(sla)
	end
end

function test_rsps()
	generate_authkey()
	get_authkey()
	get_authkey()
	println(listof_clients)

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
