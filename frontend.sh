source common.sh
component=frontend
app_path=/usr/share/nginx/html

print disable nodejs default version
dnf module disable nginx -y &>>$LOG_FILE
stat $?

cp nginx.conf /etc/nginx/nginx.conf
stat $?
print
dnf module enable nginx:1.24 -y &>>$LOG_FILE
stat $?

print installing nginx
dnf install nginx -y &>>$LOG_FILE
stat $?

APP_PREQ
 #vim /etc/nginx/nginx.
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
stat $?