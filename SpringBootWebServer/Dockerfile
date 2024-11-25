FROM FROM openjdk:17-jdk-slim
ADD target/SpringBootServer-0.0.1-SNAPSHOT.jar /usr/bin/spring-boot-server.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/bin/spring-boot-server.jar"]
