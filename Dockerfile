# Use the AdoptOpenJDK base image
FROM adoptopenjdk/openjdk11

# Create a non-root user and group with specific IDs
RUN groupadd -g 1001 appgroup && useradd -r -u 1001 -g appgroup appuser

# Set the working directory and expose the application port
ENV APP_HOME /usr/src/app
WORKDIR $APP_HOME
EXPOSE 8080

# Copy the application jar file to the container
COPY target/*.jar $APP_HOME/app.jar

# Change ownership of the app directory to the non-root user
RUN chown -R appuser:appgroup $APP_HOME

# Switch to the non-root user
USER appuser

# Specify the command to run the application
CMD ["java", "-jar", "app.jar"]
