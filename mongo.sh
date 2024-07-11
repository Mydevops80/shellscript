source common.sh
component=mongo

print Copy MongoDB repo file
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
stat $?

print installing mongodb
dnf install mongodb-org -y &>>$LOG_FILE
stat $?

print update mongod.conf file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
stat $?

print starting mongod
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod  &>>$LOG_FILE
#update the config file
systemctl restart mongod  &>>$LOG_FILE
stat $?
