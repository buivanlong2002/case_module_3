# Bước 1: Dùng image Tomcat 9 làm base
FROM tomcat:9.0

# Bước 2: Xóa các ứng dụng mặc định trong Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Bước 3: Copy WAR đã build từ Maven sang Tomcat
COPY target/Case-MD3.war /usr/local/tomcat/webapps/ROOT.war

# Tomcat mặc định chạy ở cổng 8080
EXPOSE 8080

# Mặc định CMD để chạy Tomcat
CMD ["catalina.sh", "run"]
