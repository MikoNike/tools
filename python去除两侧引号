# -*- coding: utf-8 -*-
import sys
import os

iplist = sys.argv[1].lstrip("'\"").rstrip("'\"").split(",")

for list in iplist:
    hostname = list.split('-', 2)[0]
    ip = list.split('-', 2)[1]

    #os.system('ssh root@{0} "df -h"').format(ip)
    print "更新###########{0}-{1}###########".format(hostname, ip)
    print "rsnyc -avz /data/dev root@{0}:/home/dev"
    os.system('ssh root@{0}  df -h'.format(ip))
