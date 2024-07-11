source common.sh
component=redis

print disabling default redis
dnf module disable redis -y &>>$LOG_FILE
stat $?

print enabling redis version 7
dnf module enable redis:7 -y &>>$LOG_FILE
stat $?

print installing redis
dnf install redis -y &>>$LOG_FILE
stat $?

print changing the ip 127 to 0 redis.conf file
sed -i '/^bind/ s/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>$LOG_FILE
stat $?

print changing the ip protected-mode yes to no  redis.conf file
sed -i '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$LOG_FILE
stat $?

print "Starting Redis" &>>$LOG_FILE
print "starting redis" &>>$LOG_FILE
#update redis config file
systemctl enable redis &>>$LOG_FILE
systemctl start redis &>>$LOG_FILE
stat $?