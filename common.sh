LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
source variables.sh
Nodejs(){

  cp ${component}.service /etc/systemd/system/${component}.service
  print  copying service file

  dnf module disable nodejs -y
  print  installing nodejs 20
  dnf module enable nodejs:20 -y &>>$LOG_FILE

  dnf install nodejs -y
  print adding user roboshop
  useradd roboshop &>>$LOG_FILE

  rm -rf /app &>>$LOG_FILE
  print removing directory

  mkdir /app &>>$LOG_FILE
  print creating directory

  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  print  downloading app content

  cd /app
  unzip /tmp/${component}.zip &>>$LOG_FILE
  print extracting app content

  cd /app &>>$LOG_FILE
  npm install &>>$LOG_FILE
  print download nodejs dependencies

  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}
print(){
  echo &>>LOG_FILE
  "#####################################$*###############################################" &>>$LOG_FILE
  echo $*
}

