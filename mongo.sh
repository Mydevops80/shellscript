source common.sh
component=mongo.

print  copy mongodb repo file
cp mongo.repo /etc/yum.repos.d/mongo.repo
stat$?

print installing mongodb
dnf install mongodb-org -y
stat$?

print update mongod.conf file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat$?

print starting mongod
systemctl enable mongod
systemctl start mongod
#update the config file
systemctl restart mongod
stat$?
