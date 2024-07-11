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
      echo  " refer the log file for more information : /tmp/roboshop.log"
      exit $1
  fi
}
APP_PREQ() {
  #systemctl start nginx
  print removing content from html
  rm -rf ${app_path} &>>$LOG_FILE
  stat $?

  print creating app directory
  mkdir ${app_path} &>>$LOG_FILE
  stat $?

  print downloading application content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  cd ${app_path} &>>$LOG_FILE
  stat $?

  print extracting application content
  cd ${app_path}
  unzip /tmp/${component}.zip &>>$LOG_FILE
  stat $?

}

javaservice() {
  cp shipping.service /etc/systemd/system/shipping.service
  dnf install maven -y
  useradd roboshop
  APP_PREQ
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar

  dnf install mysql -y

  mysql -h mysql.heydevops.online -uroot -pRoboShop@1 < /app/db/schema.sql
  mysql -h mysql.heydevops.online -uroot -pRoboShop@1 < /app/db/master-data.sql
  mysql -h mysql.heydevops.online -uroot -pRoboShop@1 < /app/db/app-user.sql

  systemctl daemon-reload
  systemctl enable shipping
  systemctl start shipping
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

  print download nodejs dependencies
  stat $?

  print enabling ${component}
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  stat $?
}

