The Remote Sensing Processing Service (RSPS) abstracts Cloud infrastructure and storage operations by providing numerical programming interface and uniform access to satellite data sets.

with efficient compiler.

This is possible thanks to Julia programming language

# Interacting with storage.jl

# Getting data (GET methods)

* To get the set of available datasets you can use a post method like
http://127.0.0.1:8081/detasets

It will show all the available datasets on the server

* To specify what dataset you want to get the metadata, you can add it's name to the request like:
  * You may change "portinari" to the specific dataset you want to refer
127.0.0.1:8081/detasets/portinari/meta

* To get the entire dataset,  you can use
127.0.0.1:8081/detasets/portinari/

* To edit the metadata for a dataset you can use POST calls this way

http://127.0.01:8081/datasets/portinari/metadata/foo/bar/foo2/bar2/foo3/bar3

  **Where the field/values for the metadata are listed after the toke "metadata".
  **In this case we are adding the infiormations {"foo" : "bar","foo2":"bar2","foo3":"bar3"}



# Interacting with compute_service.jl

To start using compute service just include("comput_service.jl")

* To create a container you can use deploy_container([memory, cpus])
Where memoyr and cpus are two intergers which represent the max amount of memory (in MB) the container will use and cpus is the number of cpus the container will have

* To list your containers being execute you cant use listcontainers()

* To delete an specific container you can use deletecontainer(containerid)
Where containerid is  string with the ID you can get using listcontainers()
	You can also use deleteall_containers() to delete all the containers

* The system keeps track of the containers being executed by stoing a file for each of them in .../containers

# Troubleshooting

If Docker shows the error **"Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?"**, just run:
systemctl start docker

Source: https://stackoverflow.com/questions/43401645/cannot-connect-to-the-docker-daemon-at-unix-var-run-docker-sock-is-the-docke


To open Docker without sudo, just use

*  sudo usermod -aG docker $USER
