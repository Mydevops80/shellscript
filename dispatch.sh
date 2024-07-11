source common.sh
component=dispatch
app_path=/app

APP_PREQ
print installing golang
dnf install golang -y
stat $?

print running go build
go mod init dispatch
go get
go build
SYSTEMD_SETUP