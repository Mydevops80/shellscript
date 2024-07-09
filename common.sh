LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
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
  print removing directory

  mkdir /app
  print creating directory

  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
  print  downloading app content

  cd /app
  unzip /tmp/${component}.zip
  print extracting app content

  cd /app
  npm install
  print download nodejs dependencies

  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}
print(){
  echo &>>LOG_FILE
  "###########$*###########" &>>LOG_FILE
  echo $*
}
