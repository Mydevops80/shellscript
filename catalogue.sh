source common.sh
component=catalogue
app_path=/app
Nodejs
dnf install mongodb-mongosh -y &>>$LOG_FILE
stat $?
echo loading master data

mongosh --host localhost </app/db/master-data.js
stat $?