using HTTP



id ="http://127.0.0.1:8081"
dset = "portinari/portinari.jpg"

function loaddataset(infra_id::String, dataset::String)
	
	fullpath = string(infra_id,"/",dataset)

	io = open("imagem.jpg", "w")
	r = HTTP.request("GET", fullpath, response_stream=io)


end