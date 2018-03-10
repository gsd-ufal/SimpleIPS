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
    norm_resource = target[2:length(target)] #it only removes the slash. /datasets/whatever becomes datasets/whatever
	metadsuffix = ".json"	



    if (method == "GET")	
    	tokens = Dict(zip(["directory","resource","options"], split(norm_resource,"/")))
	    fullpath = getzipedcontent(norm_resource)
	    println("Full path --------> $fullpath")

	    if(!haskey(tokens,"options")) #If there are no options tag for the request, then just send the dataset
	    	if (fullpath != 404)
	    		f = open(fullpath)     
	    		write(http, f) 
	    	else
	    		write(http,"{Error : 404}")
	    	end
	    end

    elseif (method == "POST")

    end

    

    if debug
	    #println("Stream fieldnames ",fieldnames(http),"\n")
	    #println("Message: ",http.message)
	    #println("Stream: ",http.stream)
	    #println("Writechunked: ",http.writechunked)
	    #println("Readchunked: ",http.readchunked)
	    #fullpath = string(_datasetsdir,target)
	    #println("Full path ", fullpath)
	end

       
    
    global req = http #You can use this variable to check the request stat  via terminal. 
    
    
    
end




   

