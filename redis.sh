source common.sh
component=redis

PRINT disabling default redis
dnf module disable redis -y &>>$LOG_FILE
STAT $?

PRINT enabling redis version 7
dnf module enable redis:7 -y &>>$LOG_FILE
STAT $?

PRINT installing redis
dnf install redis -y &>>$LOG_FILE
STAT $?

PRINT changing the ip 127 to 0 and changing the ip protected-mode yes to no redis.conf file
sed -i -e '/^bind/ s/127.0.0.1/0.0.0.0/'  -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
STAT $?

#PRINT changing the ip protected-mode yes to no  redis.conf file
#sed -i '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
#STAT $?
PRINT starting redis
systemctl enable redis &>>$LOG_FILE
systemctl start redis &>>$LOG_FILE
STAT $?