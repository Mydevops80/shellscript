source common.sh
component=payment
app_path=/app


APP_PREQ

print installing Payment
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
stat $?

SYSTEMD_SETUP
stat $?