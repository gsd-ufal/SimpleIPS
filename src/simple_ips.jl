using Images
using ImageView
using ImageMagick
using TestImages
using FileIO
using ParallelAccelerator
include("default_kernels.jl")




using DocOpt
using Images

type Trace
	kernel	
	iterations::Int
end


backtrace = Array(Trace,0)

macro getname(arg)
           string(arg)
       end


    

function process(session_id,kernel,input, iterations)
	img = load(input)
	img2 = kernel(img,iterations)
	
	filterName = @getname(kernel)
	outputName = string(input,"-",filterName,".png")
	save(outputName,img2)

	
	trace = Trace(kernel, iterations)	
	return trace, outputName
	
end

function process(id::Int,trace::Trace, input::String)
	process(id, trace.kernel, input,trace.iterations)
end


function traceBack(backtrace, input::String)
	lastOutput = input
	for i in backtrace
		lastOutput = process(1,i, lastOutput)[2]	
	end
end

process(1,blur,"portinari.png",1)
    


#TODO: Usar varargs keyword para deixar o usuário passar quantas keywords fields ele precisar. Vai ficar ---> setMetadata(img::String; metadata...)    

 function setMetadata(img::String; _owner="", _year="")   
	f=load(img)
	meta = properties(ImageMeta(f,owner=_owner, year=_year))

	meta_csv = Array{String}(length(meta))

	for i=1:length(meta)

		key = string(collect(meta)[i][1],";") #putting the csv separator
		value  = string(collect(meta)[i][2],"\n")
		print(key)
		print(value)
		meta_csv[i] = string(key,value)
	end

	


	output_name = string(img,"-metadata.txt")
	io = open(output_name,"w")	
	write(io,meta_csv)
	flush(io)
	close(io)

	print("Metadata saved to: ",output_name )
	print("\n")
	return meta_csv
 end




function getDatasetMetadata(name::String)
	f=open(name)

	readdlm(string(name,"-metadata.txt"),';')
	
end

