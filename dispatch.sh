source common.sh
component=dispatch
app_path=/app

APP_PREQ
print installing golang
dnf install golang -y &>>$LOG_FILE
stat $?

print running go build
go mod init dispatch &>>$LOG_FILE
go get &>>$LOG_FILE
go build &>>$LOG_FILE
SYSTEMD_SETUP