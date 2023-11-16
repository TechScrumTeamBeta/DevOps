FROM openjdk:alpine

EXPOSE 8080
ADD springbootapp.jar springbootapp.jar
ENTRYPOINT ["java","-jar","-Xms1024m","-Xmx1800m","springbootapp.jar"]

# That is going to be my base image.

# So I want to expose the port as Adad, which is the port of my application, and I'm going to add the

# spring boot app dot jar file to my container as spring boot app dot jar file.

# All right.

# So that's out of the way.

# And the last thing that I want to do is to give this application the container, an entry point to execute

# inside the container.
# So the first thing that we're going to do is, of course, to dockerize our application is to create