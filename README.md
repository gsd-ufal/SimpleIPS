# SimpleIPS
An image processing service in the cloud


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

# Troubleshooting

If Docker shows the error **"Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?"**, just run:
systemctl start docker

Source: https://stackoverflow.com/questions/43401645/cannot-connect-to-the-docker-daemon-at-unix-var-run-docker-sock-is-the-docke


To open Docker without sudo, just use

*  sudo usermod -aG docker $USER
