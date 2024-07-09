source common.sh
component=catalogue
dnf install mongodb-mongosh -y

mongosh --host mongodb.heydevops.online </app/db/master-data.js
