using HTTP
using ZipFile



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
		return string(resource,".zip")
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
		newfile = ZipFile.addfile(w,i)
		f = open(string(directory,"/",i))
		write(newfile,read(f))
	end
	close(w)
end







@async HTTP.listen() do http::HTTP.Stream  
    rq = string(http.message.target)
    
    fullpath = string(_datasetsdir,rq)
    println("Stream fieldnames ",fieldnames(http),"\n")
    println("Message: ",http.message)
    println("Stream: ",http.stream)
    println("Writechunked: ",http.writechunked)
    println("Readchunked: ",http.readchunked)
    println("Full path ", fullpath)

    println("Calling zipper on:")

    norm_resource = http.message.target[2:length(http.message.target)]


    getzipedcontent(norm_resource)
    println("====================")
    #TODO ZIPAR DIRETÓRIO COMPLETO
    f = open(fullpath) 
    write(http, f)      
    global mm = http.message

end




   
