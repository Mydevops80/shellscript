LOG_FILE=/tmp/temp.log
rm -f $LOG_FILE
if [ $? -eq 0 ] ; then
  echo -e "\e[32m Success in IF \e[0m"
else
    echo -e "\e[31m Failure \e[0m" &>>$LOG_FILE
fi
stat(){
  if [ $? -eq 0 ] ; then
    echo -e "\e[32m Success in stat \e[0m" &>>$LOG_FILE
  else
      echo -e "\e[31m Failure IN stat \e[0m" &>>$LOG_FILE
      echo "refer log file "
      exit
  fi
}
user(){
  if [ $? -ne 0 ] ; then
   useradd pavani  &>>$LOG_FILE
    fi
}
stat
user