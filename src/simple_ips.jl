using Images
using ImageView
using ImageMagick
using TestImages
using FileIO
using ParallelAccelerator

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

@acc function blur(img, iterations)
    buf = copy(img)
    runStencil(buf, img, iterations, :oob_src_zero) do b, a
       b[0,0] =
      (a[-2,-2] * 0.003  + a[-1,-2] * 0.0133 + a[0,-2] * 0.0219 + a[1,-2] * 0.0133 + a[2,-2] * 0.0030 +
       a[-2,-1] * 0.0133 + a[-1,-1] * 0.0596 + a[0,-1] * 0.0983 + a[1,-1] * 0.0596 + a[2,-1] * 0.0133 +
       a[-2, 0] * 0.0219 + a[-1, 0] * 0.0983 + a[0, 0] * 0.1621 + a[1, 0] * 0.0983 + a[2, 0] * 0.0219 +
       a[-2, 1] * 0.0133 + a[-1, 1] * 0.0596 + a[0, 1] * 0.0983 + a[1, 1] * 0.0596 + a[2, 1] * 0.0133 +
       a[-2, 2] * 0.003  + a[-1, 2] * 0.0133 + a[0, 2] * 0.0219 + a[1, 2] * 0.0133 + a[2, 2] * 0.0030)
    return a, b
    end
    return img
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

function loadDataset(infra_id::AbstractString,dataset::AbstractString)
		run(`sudo docker cp $infra_id:/opt/datasets/$dataset  .`)
end


function getDatasetMetadata(name::String)
	f=open(name)

	readdlm(string(name,"-metadata.txt"),';')
	
end

