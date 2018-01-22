installed_packages = keys(Pkg.installed())

function ispackageavaliable(packagename::String; packages=installed_packages)
		
	if packagename in installed_packages
		return true
	else
		return false
	end
	
end


function trytoinstall(packagename::String,packagegit::String;packages=installed_packages)
	if !ispackageavaliable(packagename)
		Pkg.clone(packagegit)
	end
end


trytoinstall("Images","https://github.com/JuliaImages/Images.jl.git")
trytoinstall("ImageView","https://github.com/JuliaImages/ImageView.jl.git")
#trytoinstall("ImageMagick","https://github.com/JuliaIO/ImageMagick.jl.git")
#trytoinstall("TestImages","https://github.com/JuliaIO/TestImages.jl.git")
trytoinstall("FileIO","https://github.com/JuliaIO/FileIO.jl.git")
trytoinstall("ParallelAccelerator","https://github.com/IntelLabs/ParallelAccelerator.jl.git")





