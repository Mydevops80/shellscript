LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
code_dir=pwd

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
SCHEMA_SETUP(){
  if [ "$schema_setup" == "mongo" ]; then

    print  copy mongodb repo file
    cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
    stat $?

    print install mongodb client
    dnf install mongodb-mongosh -y &>>$LOG_FILE
    stat $?

    mongosh --host localhost </app/db/master-data.js
    stat $?
    fi
  if [ "$schema_setup" == "mysql" ]; then

      print install MySQL client
      dnf install mysql -y &>>$LOG_FILE
      stat $?

      mongosh --host localhost </app/db/master-data.js
      stat $?

      print installing mysql
      dnf install mysql -y &>>$LOG_FILE
      stat $?

      print loadschema
      mysql -h localhost -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
      stat $?

      print load master data
      mysql -h localhost -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
      stat $?

      print load user data
      mysql -h localhost -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
      stat $?
      fi
}
APP_PREQ() {
  #systemctl start nginx

  print adding user roboshop
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ] ; then
    useradd roboshop &>>$LOG_FILE
    fi
  stat $?

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
JAVA_SERVICE() {

  print copying service file
  cp shipping.service /etc/systemd/system/shipping.service
  stat $?

  print  installing maven
  dnf install maven -y  &>>$LOG_FILE
  stat $?

  APP_PREQ
  mvn clean package &>>$LOG_FILE
  mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
  stat $?
  SCHEMA_SETUP

  print starting shipping
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable shipping &>>$LOG_FILE
  systemctl start shipping &>>$LOG_FILE
  stat $?

}
Nodejs(){


  dnf module disable nodejs -y &>>$LOG_FILE
  stat $?

  print  installing nodejs 20
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  stat $?

  dnf install nodejs -y &>>$LOG_FILE

  print adding user roboshop
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ] ; then
    useradd roboshop &>>$LOG_FILE
    fi
  stat $?

  APP_PREQ

  print download nodejs dependencies
  stat $?
  SYSTEMD_SETUP

}

SYSTEMD_SETUP() {
  cp ${code_dir/${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  print  copying service file
  stat $?

  print enabling ${component}
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  stat $?
}
}