LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
print(){
  echo &>>$LOG_FILE
#  echo &>>$LOG_FILE
  "#####################################$*###############################################" &>>$LOG_FILE
  echo $*
}
stat() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
  else
      echo -e "\e[31m Failure \e[0m"
      echo  " refer the log file for more information : /tmp/roboshop"
      exit $1
  fi
}
APP_PREQ() {
  #systemctl start nginx
  print removing content from html
  rm -rf ${app_path} &>>$LOG_FILE
  stat $?

  print creating app directory
  ${app_path} &>>$LOG_FILE
  stat $?

  print downloading application content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  cd ${app_path} &>>$LOG_FILE
  stat $?

  print extracting ${component} file
  cd ${app_path}
  unzip /tmp/${component}.zip &>>$LOG_FILE
  stat $?

}

Nodejs(){


  dnf module disable nodejs -y &>>$LOG_FILE
  stat $?

  print  installing nodejs 20
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  stat $?

  dnf install nodejs -y &>>$LOG_FILE


  cp ${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  print  copying service file
  stat $?

  print adding user roboshop
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ] ; then
    useradd roboshop &>>$LOG_FILE
    fi
  stat $?

  APP_PREQ

  cd /app &>>$LOG_FILE
  npm install &>>$LOG_FILE
  stat $?
  print download nodejs dependencies
  stat $?

  print enabling ${component}
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  stat $?
}

