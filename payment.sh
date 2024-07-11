source common.sh
component=payment

print installing Payment
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
stat $?


APP_PREQ
SYSTEMD_SETUP
stat $?