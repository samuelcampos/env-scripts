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
