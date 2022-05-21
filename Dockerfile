FROM harbor.jkservice.org/di/openjdk:jkstack-8-jdk-alpine
MAINTAINER chao <jichao@jingkunsystem.com>

# 设置环境变量
ENV TARGET_JAR=azure-flowlog-*.jar \
    SERVER_PORT=19010 \
    BASE_SHELL=startup.sh

# 创建目录
RUN mkdir -p $BASE_DIR

# 拷贝需要的内容
COPY ./target/${TARGET_JAR} $BASE_DIR
COPY ./bin/${BASE_SHELL} $BASE_DIR

# 设置工作目录
WORKDIR $BASE_DIR

# 添加需要的依赖
RUN sh -c "touch ${TARGET_JAR}" && chmod +x ${BASE_SHELL}


# 暴露端口
EXPOSE ${SERVER_PORT}

# 暴露挂载卷
VOLUME ["${BASE_DIR}"]

# 通过/bin/tini解决优雅关闭容器，类似于kill -15
ENTRYPOINT tini $BASE_DIR/$BASE_SHELL
