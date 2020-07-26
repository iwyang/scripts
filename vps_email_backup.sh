#!/bin/bash
# 进入到备份文件夹
cd /home/back
#压缩网站数据
tar zcvf web_$(date +"%Y%m%d").tar.gz 网站目录
# 导出数据库到备份文件夹内
mysqldump -uroot -p数据库密码 数据库名称 > web_data_$(date +"%Y%m%d").sql
# 以附件形式发送数据库到指定邮箱
echo "Blog date"|mail -s "Backup$(date +%Y-%m-%d)" -a web_data_$(date +"%Y%m%d").sql 收件人邮箱
# 删除本地3天前的数据
rm -rf web_$(date -d -3day +"%Y%m%d").tar.gz web_data_$(date -d -3day +"%Y%m%d").sql
# 登录FTP
lftp ftp地址 -u ftp用户名,ftp密码 << EOF
# 进入FTP根目录
cd ftp根目录文件夹
# 删除3天前备份文件
mrm web_$(date -d -3day +"%Y%m%d").tar.gz
mrm web_data_$(date -d -3day +"%Y%m%d").sql
# 上传当天备份文件
mput web_$(date +"%Y%m%d").tar.gz
mput web_data_$(date -d -3day +"%Y%m%d").sql
bye
EOF