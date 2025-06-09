
FROM tomcat:9.0


RUN rm -rf /usr/local/tomcat/webapps/*


COPY target/Case-MD3-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

# Lệnh khởi chạy Tomcat khi container chạy
CMD ["catalina.sh", "run"]
