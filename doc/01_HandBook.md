# 本地测试

[目录](../db)

```bash
# 打镜像
docker build -t pig-mysql .

# 启动
docker run --name pig-mysql -e MYSQL_ROOT_PASSWORD=root -d -p 3306:3306 pig-mysql
```

# redis

```bash
docker run --name pig-redis -p 6379:6379 -d redis
```

# Nacos

```bash
docker run --name nacos-standalone-derby \
    -e MODE=standalone \
    -e NACOS_AUTH_TOKEN=U2FsdGVkX2J5X3RoaXNfaXNfYV9sb25nX3JhbmRvbV9zdHJpbmdfdGhhdF93aWxsX2JlX2Jhc2U2NF9lbmNvZGVk \
    -e NACOS_AUTH_IDENTITY_KEY=serverIdentity \
    -e NACOS_AUTH_IDENTITY_VALUE=nacosServer123\
    -p 8080:8080 \
    -p 8848:8848 \
    -p 9848:9848 \
    -d nacos/nacos-server:latest
```

# 服务

### Nacos

- 访问地址：http://localhost:8080/
- 账号：Nacos/Nacos