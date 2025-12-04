# THE BUILD STAGE

# Specify the Base Image
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Specify the Working Directory
WORKDIR /app

# Copy the Project Files to the Working Directory
COPY . . 

# Build the Application
RUN mvn clean package -DskipTests


# THE RUNTIME STAGE

# Specify the Base Image
FROM eclipse-temurin:17-jdk

# Specify the Working Directory
WORKDIR /app

# Copy the Built Application from the Build Stage
COPY --from=build /app/target/*.jar /app

# Expose the Application Port
EXPOSE 8081

# Specify the Command to Run the Application
ENTRYPOINT [ "java", "-jar", "/app/tech365-0.0.1-SNAPSHOT.jar" ]