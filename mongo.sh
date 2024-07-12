source common.sh
component=mongo

PRINT Copy MongoDB repo file
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
STAT $?

PRINT installing mongodb
dnf install mongodb-org -y &>>$LOG_FILE
STAT $?

PRINT update mongod.conf file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
STAT $?

PRINT starting mongod
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod  &>>$LOG_FILE
systemctl restart mongod  &>>$LOG_FILE
STAT $?
