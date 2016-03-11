#https://gist.github.com/sqrtofsaturn/3c374ee9a49c05048112
#https://app.compose.io/octoblu/deployments/octoblu-us-west-2/mongodb/databases/meshblu/collections/devices/documents


docker rm -f aaron-redis

REDIS_CMD="docker run --name aaron-redis --rm -it redis redis-cli -h engine-simple.csy8op.0001.usw2.cache.amazonaws.com"

ENGINE_INPUT_DATA= $REDIS_CMD hget $FLOW_ID $INSTANCE_ID/engine-input/config
echo $ENGINE_INPUT_DATA
$REDIS_CMD hset $FLOW_ID $INSTANCE_ID/engine-input/config-bak $ENGINE_INPUT_DATA
$REDIS_CMD hset $FLOW_ID $INSTANCE_ID/engine-input/config "{}"
