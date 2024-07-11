source common.sh
component=rabbitmq-server

print copying repo file
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
stat $?

print installing Rabitmq
dnf install rabbitmq-server -y &>>$LOG_FILE
stat $?

print enablling Rabitmq
systemctl enable rabbitmq-server &>>$LOG_FILE
stat $?

print starting Rabitmq
systemctl start rabbitmq-server &>>$LOG_FILE
stat $?

print adding user to rabbitmq
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
stat $?