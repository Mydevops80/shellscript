LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE
Nodejs(){

  cp ${component}.service /etc/systemd/system/${component}.service
  print  copying service file
  dnf module disable nodejs -y
  print  installing nodejs 20
  dnf module enable nodejs:20 -y

  dnf install nodejs -y
  print adding user roboshop
  useradd roboshop
  rm -rf /app
  mkdir /app
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
  cd /app
  unzip /tmp/${component}.zip
  cd /app
  npm install
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}
print(){
  echo &>>LOG_FILE
  echo"###########$*###########" &>>LOG_FILE
  echo $*
}
