# Docker helpers
# - https://gist.github.com/evanscottgray/8571828
function d_stopall () {
    nContainers=$(docker ps -q | wc -l | xargs)
    echo "Stoping '$nContainers' Docker Containers"

    if [ "$nContainers" -gt "0" ]; then
        docker stop $(docker ps -q)
    fi
}
function d_removeall () {
    docker rm $(docker ps -a -q)
}

function d_in () { 
    docker exec -it $1 bash
}

function d_tail-f () { 
    docker exec -it $1 tail -f $2
}

function d_ip () 
{ 
    #docker inspect -f '{{ .NetworkSettings.IPAddress }}' $1
    docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

function d_cp () {
    docker cp $1:$2 $3
}

# Docker machine helpers

# Prepare to use Docker Machine
function d_machine ()
{
    export DOCKER_API_VERSION=1.22
    eval $(docker-machine env)

    # Check if the route for the Docker Machine already exists
    dockerMachineRoute=$(netstat -nr | grep 172.17 | wc -l)
    if [ "$dockerMachineRoute" -eq "0" ]; then
        sudo route -n add 172.17.0.0/16 $(docker-machine ip)
    fi

    # docker-machine ssh default
}
alias d_machine_in="docker-machine ssh default"