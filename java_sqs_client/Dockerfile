FROM maven:3.8-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn package -DskipTests -q

FROM eclipse-temurin:17-jre-jammy AS final

WORKDIR /app

COPY --from=builder /app/target/*.jar /app/*.jar

ENTRYPOINT ["java", "-jar", "/app/*.jar"]