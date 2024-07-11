source common.sh
component=redis

print disabling default redis
dnf module disable redis -y
stat $?

print enabling redis version 7
dnf module enable redis:7 -y
stat $?

print installing redis
dnf install redis -y
stat $?

print changing the ip 127 to 0 redis.conf file
sed -i '/^bind/ s/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

print changing the ip protected-mode yes to no  redis.conf file
sed -i '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
stat $?

print starting redis
#update redis config file
systemctl enable redis
systemctl start redis
stat $?