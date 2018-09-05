
# See:
# https://github.com/Keno/Docker.jl/blob/master/src/Docker.jl
# https://docs.docker.com/develop/sdk/examples/
# https://docs.docker.com/engine/api/v1.37/#

curl --unix-socket /var/run/docker.sock http:/v1.24/containers/jsoncurl --unix-socket /var/run/docker.sock http:/v1.24/containers/json


PAREI AQUI usar a API socket UNIX pra conectar (fazer fork da Docker.jl)

#code from https://github.com/Keno/Docker.jl
function create_container(
        host, image;
        cmd::Cmd     = ``,
        entryPoint   = "",
        tty          = true,
        attachStdin  = false,
        openStdin    = false,
        attachStdout = true,
        attachStderr = true,
        memory       = 0,
        cpuSets      = "",
        volumeDriver = "",
        portBindings = ["",""], # [ContainerPort,HostPort]
        ports        = [],
        pwd          = ""
    )
end
