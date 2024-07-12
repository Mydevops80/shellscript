source common.sh
component=rabbitmq-server

  PRINT copying repo file
  cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
  STAT $?

  PRINT installing Rabitmq
  dnf install ${component} -y &>>$LOG_FILE
  STAT $?

  PRINT enablling Rabitmq
  systemctl enable ${component} &>>$LOG_FILE
  STAT $?

  PRINT starting Rabitmq
  systemctl start ${component} &>>$LOG_FILE
  STAT $?

PRINT adding user to rabbitmq
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
STAT $?