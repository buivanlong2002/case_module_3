# Stage 1: Build project bằng Maven và JDK 8
FROM maven:3.6.3-jdk-8 AS build

# Thư mục làm việc trong container
WORKDIR /app

# Copy file cấu hình pom.xml vào trước để tải dependency cache
COPY pom.xml .

# Tải dependency trước (giúp tăng tốc khi build lại)
RUN mvn dependency:go-offline

# Copy toàn bộ mã nguồn vào container
COPY src ./src

# Build project, bỏ qua test để build nhanh
RUN mvn clean package -DskipTests

# Stage 2: Chạy app với Tomcat 9
FROM tomcat:9.0

# Xóa toàn bộ ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR đã build từ stage build sang Tomcat và đổi tên thành ROOT.war
COPY --from=build /app/target/Case-MD3-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Mở cổng 8080
EXPOSE 8080

# Lệnh chạy Tomcat
CMD ["catalina.sh", "run"]
