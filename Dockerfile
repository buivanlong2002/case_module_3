# Stage 1: Build project bằng Maven
FROM maven:3.8.7-jdk-8 AS build

# Thư mục làm việc trong container
WORKDIR /app

# Copy file cấu hình pom.xml và mã nguồn vào container
COPY pom.xml .
COPY src ./src

# Build project và tạo file WAR trong thư mục target
RUN mvn clean package -DskipTests

# Stage 2: Chạy app với Tomcat
FROM tomcat:9.0

# Xóa các ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR từ stage build sang Tomcat webapps và đổi tên thành ROOT.war
COPY --from=build /app/target/Case-MD3-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port mặc định của Tomcat
EXPOSE 8080

# Lệnh chạy Tomcat
CMD ["catalina.sh", "run"]
