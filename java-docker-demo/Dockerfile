# -------- Build Stage --------
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# -------- Runtime Stage --------
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/demo-0.0.1.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
