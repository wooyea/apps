
export DOCKER_CONTAINER_NAME=${INSTANCE_NAME}-${APP_NAME}

app_env_init() {
    [ -d $APP_LOG_DIR ] || su_run "mkdir -p $APP_LOG_DIR"
}

app_start() {
    docker start $DOCKER_CONTAINER_NAME
}

app_stop() {
    docker stop $DOCKER_CONTAINER_NAME
}

app_kill() {
    docker kill $DOCKER_CONTAINER_NAME
}

app_clear() {
    docker rm -v $DOCKER_CONTAINER_NAME
}

app_log() {
    docker logs $DOCKER_CONTAINER_NAME
}

app_status() {
    docker stats $DOCKER_CONTAINER_NAME
}
