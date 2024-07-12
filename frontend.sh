source common.sh
component=frontend
app_path=/usr/share/nginx/html

PRINT disable nodejs default version
dnf module disable nginx -y &>>$LOG_FILE
STAT $?


PRINT enabling nginx 1.24
dnf module enable nginx:1.24 -y &>>$LOG_FILE
STAT $?

PRINT installing nginx
dnf install nginx -y &>>$LOG_FILE
STAT $?

PRINT creating a  nginx conf file
cp nginx.conf /etc/nginx/nginx.conf
STAT $?

APP_PREREQ


PRINT enabiling nginx
systemctl enable nginx &>>$LOG_FILE
STAT $?

PRINT starting nginx
systemctl start nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
STAT $?