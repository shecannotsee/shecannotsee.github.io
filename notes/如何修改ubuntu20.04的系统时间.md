#### 1.关闭同步配置

```bash
sudo vim /etc/systemd/timesyncd.conf
```

设置

```ini
[Time]
#NTP=
```

为

```ini
[Time]
NTP=off
```

#### 2.关闭自动同步时间的服务

```bash
sudo systemctl stop systemd-timesyncd
```

接下来就可以随意修改时间了

```bash
# 时间往后调整一分钟(未来),12:00 -> 12:01
sudo date -s "1 minute"
# 时间往前调整一分钟(过去),12:00 -> 11:59
sudo date -s "1 minute ago" 

# 时间往后调整一小时(未来),12:00 -> 13:00
sudo date -s "1 minute"
# 时间往前调整一小时(过去),12:00 -> 11:00
sudo date -s "1 minute ago" 
```



#### 3.如何开启同步

将`/etc/systemd/timesyncd.conf`改回来

然后启动同步时间服务即可

```bash
sudo systemctl start systemd-timesyncd
```

