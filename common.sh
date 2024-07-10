LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
Nodejs(){

  cp ${component}.service /etc/systemd/system/${component}.service
  print  copying service file
  dnf module disable nodejs -y
  stat $?

  print  installing nodejs 20
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  stat $?

  dnf install nodejs -y
  print adding user roboshop
  useradd roboshop &>>$LOG_FILE
  stat $?

  rm -rf /app &>>$LOG_FILE
  print removing directory
  stat $?

  mkdir /app &>>$LOG_FILE
  print creating directory
  stat $?

  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  print  downloading app content
  stat $?

  cd /app
  unzip /tmp/${component}.zip &>>$LOG_FILE
  print extracting app content
  stat $?

  cd /app &>>$LOG_FILE
  npm install &>>$LOG_FILE
  print download nodejs dependencies
  stat $?

  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  stat $?
}
print(){
  echo &>>LOG_FILE
  "#####################################$*###############################################" &>>$LOG_FILE
  echo $*
}
stat(){
  if [ $? -eq 0 ] ; then
    echo -e "\e[32m Success \e[0m" &>>$LOG_FILE
  else
      echo -e "\e[31m Failure \e[0m" &>>$LOG_FILE
      echo  -e"\e[31m refer log file \e[0m  /tmp/roboshop"
      exit
  fi
}

