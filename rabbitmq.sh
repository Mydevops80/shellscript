source common.sh
component=rabbitmq-server

print schema setup
SCHEMA_SETUP rabbitmq
stat $?

print adding user to rabbitmq
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
stat $?