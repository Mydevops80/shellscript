source common.sh
component=mongo

PRINT install mysql server
dnf install mysql-server -y &>>$LOG_FILE
STAT $?

PRINT starting mysqld
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
STAT $?

PRINT setup mysql rootpassword
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
STAT $?