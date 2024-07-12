source common.sh
component=payment
app_path=/app


APP_PREREQ

PRINT installing Payment
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
STAT $?

SYSTEMD_SETUP
STAT $?