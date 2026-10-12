# Use official Maven image for Java 17
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the pom.xml file first
COPY pom.xml .

# Download dependencies (cached unless pom.xml changes)
RUN mvn dependency:go-offline -B

# Copy the project source
COPY src src

# Build the application
RUN mvn clean package -DskipTests

# Use a smaller JRE image for runtime
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port (Cloud Run defaults to 8080)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
