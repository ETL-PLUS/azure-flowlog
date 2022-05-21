#!/bin/sh
# 可以通过docker容器中的-e命令覆盖当前参数,添加默认可以使用如下参数`:=添加的参数`
export JAVA_OPTS=${JAVA_OPTS}
export TARGET_JAR=${TARGET_JAR}

# 如何没设置，添加一个默认 UseStringDeduplication: 结合g1gc来实现，减少string数据区的大小
if [ -z "$JAVA_OPTS" ]; then
  JAVA_OPTS="-server -Xms1024m -Xmx1024m -Xss256k -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:+UseStringDeduplication -XX:+HeapDumpOnOutOfMemoryError -XX:ErrorFile=./logs/dataflow-web_error_%p.log -XX:HeapDumpPath=./logs/azure_flowlog_error.hprof"
fi

export JAVA_OPTS="${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -Dfile.encoding=UTF-8"

core_size=$(grep -c ^processor /proc/cpuinfo)
if [ -z "$FORK_JOIN_POOL_SIZE" ]; then
  export FORK_JOIN_POOL_SIZE=$(($core_size + 4))
fi
loop_size=$(($core_size/2))

export JAVA_OPTS="${JAVA_OPTS} -Djava.util.concurrent.ForkJoinPool.common.parallelism=$FORK_JOIN_POOL_SIZE -Dio.netty.eventLoopThreads=$loop_size"

# 启动当前服务
exec java $JAVA_OPTS -jar $TARGET_JAR