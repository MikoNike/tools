#!/bin/bash

#####################################
#                                   
#       Centos7优化脚本              
#                                   
#####################################

IPTABLES='/sbin/iptables'

#清空防火墙
function Clean_iptables() {
    echo "清空iptables ....."
    $IPTABLES -F
    $IPTABLES -X

}

#关闭selinux
function Enable_SeLinux() {
    echo "关闭SELinux ....."
    setenforce 0
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config 
}

#更新yum仓库以及软件
function Update_pkg() {
    echo "安装epel-release并更新yum仓库以及软件"
    yum -y install epel-release
    yum update && yum -y install ntpdate sysstat lrzsz wget nmap tree curl lsof nano bash-completion net-tools lsof vim-enhanced htop 
}

#禁用IPV6
function Enable_IPV6() {
    echo "禁止ipv6"
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
}

#内核优化
function Kernel_tuning() {
echo "内核优化"
cat >>/etc/sysctl.conf<<EOF  
net.ipv4.tcp_fin_timeout = 1  
net.ipv4.tcp_keepalive_time = 1200  
net.ipv4.tcp_mem = 94500000 915000000 927000000  
net.ipv4.tcp_tw_reuse = 1  
net.ipv4.tcp_timestamps = 0  
net.ipv4.tcp_synack_retries = 1  
net.ipv4.tcp_syn_retries = 1  
net.ipv4.tcp_tw_recycle = 1  
net.core.rmem_max = 16777216  
net.core.wmem_max = 16777216  
net.core.netdev_max_backlog = 262144  
net.ipv4.tcp_max_orphans = 3276800  
net.ipv4.tcp_max_syn_backlog = 262144  
net.core.wmem_default = 8388608  
net.core.rmem_default = 8388608  
EOF

/sbin/sysctl -p

\cp /etc/security/limits.conf /etc/security/limits.conf.$(date +%F)
ulimit -HSn 65535
echo -ne "
* soft nofile 65535
* hard nofile 65535
" >>/etc/security/limits.conf

echo "ulimit -c unlimited" >> /etc/profile
source /etc/profile

}

#修改shell命令的history 记录个数和连接超时时间
function Change_shell() {
    echo "export HISTCONTROL=ignorespace" >>/etc/profile
    echo "export HISTCONTROL=erasedups" >>/etc/profile
    echo "HISTSIZE=500" >> /etc/profile
    source /etc/profile

}



function main() {
    Clean_iptables
    Enable_SeLinux
    Update_pkg
    Enable_IPV6
    Kernel_tuning
    Change_shell
}
