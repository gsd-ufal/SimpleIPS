using HTTP
using ZipFile
using JSON

global debug = false

_datasetsdir = string(pwd(),"/datasets")

"Gets a dataset name and a dictionary of metadatafield => fieldvalue and updates the metadata for that specified dataset"
function updatemetadata(dataset::String,metadata::Dict)

end


"Sends the specified datset to the requesting infraID.
This function is to be called when an user send a load dataset request"
function senddataset(dset_name::String, infra_id::String, auth_token::String)
	dataset = string(_datasetsdir,dset_name)

end



"Return all the available datasets"
function listdatasets(ddatasetsdir = _datasetsdir)
	list = readdir(string(_datasetsdir))
end


function getzipedcontent(directory::String)
	resource = split(directory,"/")
	resource = resource[length(resource)]
	rsc_zip = string(resource,".zip")
	println("rsc_zip ~~>",rsc_zip)
	println("resource ~~>",resource)

	files = -1 #Gotta create this variable out of the try catch body
	try
		files = readdir(directory)
	catch
		println("The resource ",directory," does not exist.\n")
		return 404
	end

	if (length(files) > 0)


		if (!contains(==,files,rsc_zip)) #if the zip is not already created
			println("Ziping up")
			zipcontent(directory)
		end

		#TODO generate request???
		println("Sending resource request")
		return string(directory,"/",resource,".zip")
		return 200
	end

	return 404
end

function zipcontent(directory::String)

	resource = split(directory,"/")
	resource = resource[length(resource)]
	files = readdir(directory)

	w = ZipFile.Writer(string(directory,"/",resource,".zip"))
	for i in files
		try	#the attribution creating the variable w creates the .zip file, but its unacessible at the moment of this loop. This try catch is to bypass the error message
			newfile = ZipFile.addfile(w,i)
			f = open(string(directory,"/",i))
			write(newfile,read(f))
		catch

		end
	end
	close(w)
end







@async HTTP.listen() do http::HTTP.Stream


    target = string(http.message.target)
    method = http.message.method
    norm_resource = target[2:length(target)] #it only removes the slash. /datasets/whatever becomes datasets/whatever.
	metadatafile = "metadata.json"



    if (method == "GET")
    	tkns = Dict(zip(["dir","res","opts"], split(norm_resource,"/")))


    	 if (!haskey(tkns,"res"))
    	 	datasetslist = JSON.json(Dict("datasets" => readdir("datasets")))
	    	write(http, datasetslist)
	    	return 202
	    end


	    zippath = getzipedcontent(   join([tkns["dir"],tkns["res"]],"/")    ) #--->generating the .zip for the resource. From the directory/resource/options uri, it only considers the directory/resource part

	    println("Zip path --------> $zippath")




	    if(!haskey(tkns,"opts")) #If there are no options tag for the request, then just send the dataset
	    	if (zippath != 404)
	    		f = open(zippath)
	    		write(http, f)
	    	else
	    		write(http,"{Error : 404}")
	    	end
	    elseif (tkns["opts"] == "metadata" || tkns["opts"] == "meta")
	    	metadatapath = join([tkns["dir"],tkns["res"],metadatafile],"/")
	    	f = open(metadatapath)
	    	write(http, f)
	    end

    elseif (method == "POST")

	#println("======\n",norm_resource,"======\n")

	tkns = Dict(zip(["dir","res","opts"], split(norm_resource,"/"))) #datasets/portinari/meta/key1/value1/key2/value2/.../keyn/valuen

	if (tkns["opts"] == "meta" || tkns["opts"] == "metadata" )


		tokens_path = string(   tkns["dir"],  "/",   tkns["res"],   "/", tkns["opts"],  "/")
		res_path = string(   tkns["dir"],  "/",   tkns["res"],   "/")
		attributes = replace(norm_resource, tokens_path,"")
		attributes = split(attributes,"/")

		println("---------------\n")
		if (length(attributes) >= 2 && length(attributes)%2 == 0)

			meta_keys = [x for x in attributes[1:2:length(attributes)]]
			meta_values = [x for x in attributes[2:2:length(attributes)]]
			dict_metadata = Dict(zip(meta_keys,meta_values))

			json_metadata = JSON.json(dict_metadata)
			json_path = string(res_path,metadatafile)
			f = open(json_path,"w+")
			write(f,json_metadata)
			flush(f)
			close(f)

			#TODO update tue currently zipfile instead of deleting it and expecting for the next request to create a new one
			try
				zip_path = string(res_path,tkns["res"],".zip")
				rm(zip_path)
			catch
			end

			write(http, "{Status : 200, Message : Metadata updated}")
		else
			write(http, "{Status : 400, Message: You must provide key/value pairs on the request.}")
		end
    else
		property = tkns["opts"]
		write(http, "{Status : 503, Message : Bad request -- The property $property does not exist.}")
	end



    if debug
	    #println("Stream fieldnames ",fieldnames(http),"\n")
	    #println("Message: ",http.message)
	    #println("Stream: ",http.stream)
	    #println("Writechunked: ",http.writechunked)
	    #println("Readchunked: ",http.readchunked)
	    #zippath = string(_datasetsdir,target)
	    #println("Full path ", zippath)
	end



    global req = http #You can use this variable to check the request stat  via terminal.

end

end
