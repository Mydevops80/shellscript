source common.sh
component=payment
app_path=/app


PRINT installing Payment
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
STAT $?


APP_PREREQ
SYSTEMD_SETUP
STAT $?