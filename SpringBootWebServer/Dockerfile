FROM balenalib/aarch64-debian-openjdk:17-latest
ADD target/SpringBootServer-0.0.1-SNAPSHOT.jar /usr/bin/spring-boot-server.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/bin/spring-boot-server.jar"]
