source common.sh
component=mongo

print install mysql server
dnf install mysql-server -y &>>$LOG_FILE
STAT $?

print starting mysqld
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
STAT $?

print setup mysql rootpassword
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
STAT $?