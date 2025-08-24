# --- Giai đoạn build với Maven ---
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy file settings.xml vào thư mục cấu hình Maven
COPY settings.xml /root/.m2/settings.xml

# Copy toàn bộ source code
COPY . .

# Build project, bỏ qua test
RUN mvn clean package -DskipTests

# --- Giai đoạn runtime ---
FROM openjdk:17-jdk-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        zip unzip curl tzdata rsync openssh-client grep coreutils vim sed procps net-tools tree && \
    rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN useradd -m appuser

WORKDIR /app

COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar
COPY ./src/main/resources/application.properties /app/config/application.properties

RUN mkdir -p /app/logs && chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar", "--spring.config.location=file:/app/config/application.properties"]