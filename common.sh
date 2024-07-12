LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
code_dir=$(pwd)
PRINT(){
  echo &>>$LOG_FILE
  echo &>>$LOG_FILE
  "#####################################$*###############################################" &>>$LOG_FILE
  echo $*
}
STAT() {
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
  mkdir ${app_path} &>>$LOG_FILE
  STAT $?

  PRINT downloading application content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  cd ${app_path} &>>$LOG_FILE
  STAT $?

  PRINT extracting application content
  cd ${app_path}
  unzip /tmp/${component}.zip &>>$LOG_FILE
  STAT $?

}
SYSTEMD_SETUP() {

  PRINT  copying service file
  cp ${code_dir}/${component}.service /etc/systemd/system/${component}.service  &>>$LOG_FILE
  STAT $?

  PRINT enabling ${component}
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  STAT $?
}

NODEJS() {
  dnf module disable nodejs -y &>>$LOG_FILE
  STAT $?

  PRINT  installing nodejs 20
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  STAT $?

  dnf install nodejs -y &>>$LOG_FILE

  PRINT adding user roboshop
  id roboshop &>>$LOG_FILE
  if [ $? -ne 0 ] ; then
    useradd roboshop &>>$LOG_FILE
  fi
  STAT $?

  APP_PREQ

  PRINT download nodejs dependencies
  npm install &>>$LOG_FILE
  STAT $?

  SCHEMA_SETUP
  SYSTEMD_SETUP

}


JAVA_SERVICE() {

  PRINT copying service file
  cp ${component}.service /etc/systemd/system/${component}.service
  STAT $?

  PRINT  installing maven
  dnf install maven -y  &>>$LOG_FILE
  STAT $?

  APP_PREQ
  mvn clean package &>>$LOG_FILE
  mv target/${component}-1.0.jar ${component}.jar &>>$LOG_FILE
  STAT $?

  PRINT schemasetup
  SCHEMA_SETUP
  STAT $?

  PRINT starting ${component}
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl start ${component} &>>$LOG_FILE
  STAT $?

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

      mongosh --host mongod.heydevops.online </app/db/master-data.js
      STAT $?

      PRINT installing mysql
      dnf install mysql -y &>>$LOG_FILE
      STAT $?

      PRINT loadschema
      mysql -h mysql.heydevops.online -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
      STAT $?

      PRINT load master data
      mysql -h mysql.heydevops.online -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
      STAT $?

      PRINT load user data
      mysql -h mysql.heydevops.online -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
      STAT $?

  fi

}

