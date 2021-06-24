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
#oss里面的目录
Bucket_dir = ''


auth = oss2.Auth(AccessKeyId, AccessKeySecret)
# yourEndpoint填写Bucket所在地域对应的Endpoint。以华东1（杭州）为例，Endpoint填写为https://oss-cn-hangzhou.aliyuncs.com。
# 填写Bucket名称。
bucket = oss2.Bucket(auth, Endpoint, BucketName)

logfile = os.popen('find %s -mtime -3 -type f'%(log_dir)).readlines()
for i in logfile:
    bucket.put_object_from_file('%s/%s'%(Bucket_dir,os.path.basename(i)), i.replace('\n',''))
    print i + '文件已上传'
