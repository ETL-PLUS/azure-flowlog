VERSION=1.0.0

# 构建
mvn clean package -DskipTests -f ./pom.xml

# 构建  docker tag SOURCE_IMAGE[:TAG] harbor.jkservice.org/di/REPOSITORY[:TAG]
docker build --tag harbor.jkservice.org/di/azure_flowlog:${VERSION} .

## 推送镜像道harbor仓库中 ，注意推送前需要docker login登录一下   docker login --username jichao,因为凭证为题，还需要添加安全的相关配置才能登录成功
docker push harbor.jkservice.org/di/azure_flowlog:${VERSION}
