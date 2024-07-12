LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
code_dir=$(pwd)

PRINT() {
  echo &>>$LOG_FILE
  echo &>>$LOG_FILE
  echo " ####################################### $* ########################################" &>>$LOG_FILE
  echo $*
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSuccess\e[0m"
  else
      echo -e "\e[31mFailure\e[0m"
      echo
      echo  " refer the log file for more information : ${LOG_FILE}"
      exit $1
  fi
}

APP_PREREQ() {
  PRINT adding user roboshop
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ] ; then
    useradd roboshop &>>$LOG_FILE
  fi
  STAT $?

  PRINT removing  application content
  rm -rf ${app_path} &>>$LOG_FILE
  STAT $?

  PRINT creating app directory
  mkdir ${app_path}  &>>$LOG_FILE
  STAT $?

  PRINT downloading application content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip  &>>$LOG_FILE
  STAT $?

  PRINT extracting application content
  cd ${app_path}
  unzip /tmp/${component}.zip  &>>$LOG_FILE
  STAT $?

}
SYSTEMD_SETUP() {
  PRINT  copying service file
  cp ${code_dir}/${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  STAT $?

  PRINT Start Service
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  STAT $?
}

NODEJS() {
  PRINT Disable NodeJS Default Version
  dnf module disable nodejs -y &>>$LOG_FILE
  STAT $?

  PRINT  installing nodejs 20 module
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  STAT $?

  PRINT Install Nodejs
  dnf install nodejs -y &>>$LOG_FILE
  STAT $?

  APP_PREREQ

  PRINT download nodejs dependencies
  npm install &>>$LOG_FILE
  STAT $?

  SCHEMA_SETUP
  SYSTEMD_SETUP

}


JAVA() {

  PRINT  installing maven and JAVA
  dnf install maven -y  &>>$LOG_FILE
  STAT $?

  APP_PREREQ
  mvn clean package &>>$LOG_FILE
  STAT $?

  mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE

 SCHEMA_SETUP
 SYSTEMD_SETUP

}

SCHEMA_SETUP(){
  if [ "$schema_setup" == "mongo" ]; then
    PRINT  copy mongodb repo file
    cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
    STAT $?

    PRINT install mongodb client
    dnf install mongodb-mongosh -y &>>$LOG_FILE
    STAT $?

    mongosh --host mongod.heydevops.online </app/db/master-data.js
    STAT $?
  fi

  if [ "$schema_setup" == "mysql" ]; then

      PRINT install MySQL client
      dnf install mysql -y &>>$LOG_FILE
      STAT $?

    for file in schema master-data app-user; do
      PRINT Load file - $file.sql
      mysql -h mysql.heydevops.online -uroot -pRoboShop@1 < /app/db/$file.sql &>>$LOG_FILE
      STAT $?
    done

  fi

}