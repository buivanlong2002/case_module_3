# Stage 1: Build ứng dụng bằng Maven
FROM maven:3.8.5-openjdk-17 AS build

# Đặt thư mục làm việc trong container
WORKDIR /app

# Copy toàn bộ source code vào container
COPY . .

# Build project, tạo file .war (bỏ qua test để nhanh hơn)
RUN mvn clean package -DskipTests

# Stage 2: Chạy file WAR trên Tomcat 9
FROM tomcat:9.0

# Xóa các ứng dụng mặc định trong Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR được build ở stage 1 vào thư mục webapps của Tomcat
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Mở port 8080 mặc định của Tomcat
EXPOSE 8080

# Lệnh chạy Tomcat khi container khởi động
CMD ["catalina.sh", "run"]
