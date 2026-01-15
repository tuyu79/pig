FROM amazoncorretto:17.0.17-al2023-headless

WORKDIR /pig-upms-biz

ARG JAR_FILE=target/pig-upms-biz.jar

COPY ${JAR_FILE} app.jar

EXPOSE 4000

ENV TZ=Asia/Shanghai JAVA_OPTS="-Xms128m -Xmx256m -Djava.security.egd=file:/dev/./urandom"

CMD java $JAVA_OPTS -jar app.jar
