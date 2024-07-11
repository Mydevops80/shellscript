source common.sh
component=payment
app_path=/app

print installing Payment
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
stat $?


APP_PREQ
SYSTEMD_SETUP
stat $?