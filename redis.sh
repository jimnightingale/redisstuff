#PASSWD=
#USR=

#sudo adduser -p $(openssl passwd -1 $PASSWD) $USR
#sudo gpasswd -a $USR wheel

sudo yum install -y sshpass

sudo mkdir -p /etc/redis
sudo mkdir /var/lib/redis
sudo chmod 777 /var/lib/redis


sudo adduser --system --user-group --no-create-home redis


#sudo scp $USR@srv:/etc/redis/redis.conf /etc/redis/
sudo sshpass -p $PASSWD scp $USR@srv:/etc/redis/redis.conf /etc/redis/
sudo sshpass -p $PASSWD scp $USR@srv:/etc/systemd/system/redis.service /etc/systemd/system/
sudo sshpass -p $PASSWD scp $USR@srv:/usr/local/bin/redis-benchmark /usr/local/bin/
sudo sshpass -p $PASSWD scp $USR@srv:/usr/local/bin/redis-check-aof /usr/local/bin/
sudo sshpass -p $PASSWD scp $USR@srv:/usr/local/bin/redis-check-rdb /usr/local/bin/
sudo sshpass -p $PASSWD scp $USR@srv:/usr/local/bin/redis-cli /usr/local/bin/
sudo sshpass -p $PASSWD scp $USR@srv:/usr/local/bin/redis-server /usr/local/bin/

cd /usr/local/bin
sudo ln -s  redis-server /usr/local/bin/redis-sentinel

echo ** edit bind address in /etc/redis/redis.conf

# redis conf
## bind
## slaveof masterip masterport
## slave-serve-stale-data no #if master is down then no data is served
## slave-serve-stale-data yes
## slave-read-only yes
## repl-diskless-sync no
## repl-disable-tcp-nodelay no

# copy sentinel.conf to /etc/redis/sentinel.conf
# sentinel conf
## protected-mode no
## port 26379
## dir /tmp
## sentinel monitor redis1 10.240.0.2 6379 2
## sentinel down-after-milliseconds redis1 5000
## sentinel parallel-syncs redis1 1
## sentinel failover-timeout redis1 180000

# hack
# /etc/systemd/system/sentinel.service
## [Unit]
## Description=Redis Sentinel - Redis failover
## After=network.target
## [Service]
## ExecStart=/usr/local/bin/redis-sentinel /etc/redis/sentinel.conf
## ExecStop=/usr/bin/pkill redis-sentinel
## [Install]
## WantedBy=multi-user.target


