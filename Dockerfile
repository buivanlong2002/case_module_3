# Sử dụng Tomcat 9 làm base image
FROM tomcat:9.0

# Xóa các ứng dụng mặc định trong Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR từ thư mục target vào thư mục webapps của Tomcat, đổi tên thành ROOT.war để triển khai ứng dụng mặc định
COPY target/Case-MD3-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose cổng 8080 (mặc định Tomcat chạy cổng này)
EXPOSE 8080

# Lệnh khởi chạy Tomcat khi container chạy
CMD ["catalina.sh", "run"]

