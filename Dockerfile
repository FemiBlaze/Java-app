# THE BUILD STAGE

# Specify the Base Image
FROM maven:3.8.4-openjdk-17-slim AS build

# Specify the Working Directory
WORKDIR /app

# Copy the Project Files to the Working Directory
COPY . . 

# Build the Application
RUN mvn clean package -DskipTests


# THE RUNTIME STAGE

# Specify the Base Image
FROM openjdk:17-slim

# Specify the Working Directory
WORKDIR /app

# Copy the Built Application from the Build Stage
COPY --from=build /app/target/*.jar /app

# Expose the Application Port
EXPOSE 8081

# Specify the Command to Run the Application
ENTRYPOINT [ "java", "-jar", "/app/tech365-0.0.1-SNAPSHOT.jar" ]