# Stage 1: Build the app
FROM maven:3.9.3-eclipse-temurin-17-alpine AS build

WORKDIR /app

# Copy pom.xml and download dependencies first
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy all source code (including application.yml)
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Run the app
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the built jar from stage 1
COPY --from=build /app/target/*.jar app.jar

# Expose the default port
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
