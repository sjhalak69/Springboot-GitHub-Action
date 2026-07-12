FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests


FROM eclipse-temurin:17-jre-alpine AS runner
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["sh","-c","java -jar app.jar & nginx -g 'daemon off;'"]
