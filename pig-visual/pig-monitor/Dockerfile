FROM amazoncorretto:17.0.17-al2023-headless

WORKDIR /pig-monitor

ARG JAR_FILE=target/pig-monitor.jar

COPY ${JAR_FILE} app.jar

EXPOSE 5001

ENV TZ=Asia/Shanghai JAVA_OPTS="-Xms128m -Xmx256m -Djava.security.egd=file:/dev/./urandom"

CMD java $JAVA_OPTS -jar app.jar
