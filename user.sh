source common.sh
component=user

print copying service file  &>>$LOG_FILE
cp user.service /etc/systemd/system/user.service &>>$LOG_FILE
stat $?

Nodejs

