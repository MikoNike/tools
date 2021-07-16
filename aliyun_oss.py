# -*- coding: utf-8 -*-
import oss2
import os
import time
from datetime import datetime

#TODO:运行环境Python2.X 使用时安装模块 运行命令 pip install oss2

AccessKeyId = ''
AccessKeySecret = ''
#OSS地址
Endpoint = ''
#Bucket名称
BucketName = ''
#log地址
log_dir = ''
#oss里面的目录 什么都不写为空默认放到/下
Bucket_dir = ''
# 最近N天的文件
# 参数说明
# +3    3天前的文件
# -3    3天内的文件
date_time= '+3'

auth = oss2.Auth(AccessKeyId, AccessKeySecret)
# yourEndpoint填写Bucket所在地域对应的Endpoint。以华东1（杭州）为例，Endpoint填写为https://oss-cn-hangzhou.aliyuncs.com。
# 填写Bucket名称。
bucket = oss2.Bucket(auth, Endpoint, BucketName)

logfile = os.popen('find %s -mtime %s -type f'%(log_dir, date_time)).readlines()
for i in logfile:
    bucket.put_object_from_file('%s%s'%(Bucket_dir,os.path.basename(i)), i.replace('\n',''))
    print i + '文件已上传'
