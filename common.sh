Nodejs(){
  cp ${component}.service /etc/systemd/system/${component}.service
  dnf module disable nodejs -y
  dnf module enable nodejs:20 -y
  dnf install nodejs -y
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
