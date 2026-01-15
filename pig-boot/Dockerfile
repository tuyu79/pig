FROM openjdk:17

WORKDIR /pig-boot

ARG JAR_FILE=target/pig-boot.jar

COPY ${JAR_FILE} app.jar

EXPOSE 9999

ENV TZ=Asia/Shanghai JAVA_OPTS="-Xms512m -Xmx1024m -Djava.security.egd=file:/dev/./urandom"

CMD java $JAVA_OPTS -jar app.jar
