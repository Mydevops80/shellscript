source common.sh
component=dispatch
app_path=/app

APP_PREREQ
PRINT installing golang
dnf install golang -y &>>$LOG_FILE
STAT $?

PRINT running go build
go mod init dispatch &>>$LOG_FILE
go get &>>$LOG_FILE
go build &>>$LOG_FILE
SYSTEMD_SETUP