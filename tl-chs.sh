#!/bin/bash
# shell by XYNS(Wigiesen)
# GitHub: https://github.com/Wigiesen
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8

# 检查系统是否是64bit
is64bit=$(getconf LONG_BIT)
if [ "${is64bit}" != '64' ];then
    echo -e "\033[41m抱歉, 当前脚本不支持CentOS 32位系统, 请使用CentOS 64位系统.\033[0m"
    exit;
fi

echo -e "\033[46;30m+---------------------------------------------------------+\033[0m"
echo -e "\033[46;31m|                作者: 心语难诉 QQ:437723442              |\033[0m"
echo -e "\033[46;31m|                 二开: 刺刺 QQ:990865490                 |\033[0m"
echo -e "\033[46;30m+---------------------------------------------------------+\033[0m"
echo -e "\033[46;30m| (0).安装TLBB服务器环境到 CentOS 5.8                     |\033[0m"
echo -e "\033[46;30m| (1).安装TLBB服务器环境到 CentOS 6.5                     |\033[0m"
echo -e "\033[46;30m| (2).安装TLBB服务器环境到 CentOS 7.x                     |\033[0m"
echo -e "\033[46;30m| (3).安装TLBB服务器环境到 CentOS 8.x                     |\033[0m"
echo -e "\033[46;30m| (4).执行删档                                            |\033[0m"
echo -e "\033[46;30m| (5).退出                                                |\033[0m"
echo -e "\033[46;30m+---------------------------------------------------------+\033[0m"

# CentOS5.8安装
Install_58(){
    if [ ! -f "/opt/tlbbfor5.8.tar.gz" ];then
        wget -P /opt http://liebiao071.oss-cn-beijing.aliyuncs.com//tlbbfor5.8.tar.gz
    fi

    tar -zxvf /opt/tlbbfor5.8.tar.gz -C /opt
    # 设置数据库密码
    read -p "请输入您需要设置的MySQL数据库密码: " dbpass;

    LimitIsTure=0
    while [[ "$LimitIsTure" == 0 ]]
    do
        if [[ "${#dbpass}" -ge 1 ]];then
            LimitIsTure=1
        else
            read -p "密码必须大于等于1位,请重新输入 : " dbpass;
        fi
    done
    # 进入安装目录
    cd /opt

    # 卸载自带MySQL, 更换CentOS5.8源
    sudo yum -y remove mysql*
    rm -rf /usr/bin/mysql
    rm -rf /var/lib/mysql
    rm -rf /var/lib/mysql/

    rm -rf /etc/yum.repos.d\\1${dbpass}/" /etc/odbc.ini

    #重启MYSQL并打开自动重启
    /etc/rc.d/init.d/mysqld restart
    chkconfig mysqld on

    #清空操作记录
    cat /dev/null >/root/.mysql_history
    cat /dev/null >/root/.bash_history
}

# CentOS6.5安装
Install_65(){
    if [ ! -f "/opt/tlbbfor6.5.tar.gz" ];then
        wget -P /opt http://liebiao071.oss-cn-beijing.aliyuncs.com//tlbbfor6.5.tar.gz
    fi
    tar -zxvf /opt/tlbbfor6.5.tar.gz -C /opt
    # 设置数据库密码
    read -p "请输入您需要设置的MySQL数据库密码: " dbpass;
    LimitIsTure=0
    while [[ "$LimitIsTure" == 0 ]]
    do
        if [[ "${#dbpass}" -ge 1 ]];then
            LimitIsTure=1
        else
            read -p "密码必须大于等于1位,请重新输入 : " dbpass;
        fi
    done

    # 进入安装目录
    cd /opt
    rm -rf /etc/yum.repos.d\\1${dbpass}/" /etc/odbc.ini

    #重启MYSQL并打开自动重启
    /etc/rc.d/init.d/mysql restart
    chkconfig mysql on

    #清空操作记录
    cat /dev/null >/root/.mysql_history
    cat /dev/null >/root/.bash_history
}

# CentOS7.x安装
Install_7x(){
    if [ ! -f "/opt/tlbbfor7x.tar.gz" ];then
        wget -P /opt http://liebiao071.oss-cn-beijing.aliyuncs.com//tlbbfor7x.tar.gz
    fi
    tar zxvf /opt/tlbbfor7x.tar.gz -C /opt
    # 设置数据库密码
    read -p "请输入您需要设置的MySQL数据库密码: " dbpass;
    LimitIsTure=0
    while [[ "$LimitIsTure" == 0 ]]
    do
        if [[ "${#dbpass}" -ge 1 ]];then
            LimitIsTure=1
        else
            read -p "密码必须大于等于1位,请重新输入 : " dbpass;
        fi
    done

    # 进入安装目录
    cd /opt

    # 数据库安装
    yum -y remove mysql-libs
    tar zxvf MySQL.tar.gz
    rpm -ivh mysql-client.rpm --nodeps --force
    rpm -ivh mysql-server.rpm --nodeps --force

    # 数据库权限相关操作
    mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'root' with grant option;";
    mysql -e "use mysql;update user set password=password('${dbpass}') where user='root';";
    mysql -e "create database tlbb;";
    mysql -e "flush privileges;";

    # 配置ODBC
    sed -i "s/PassWord=123456/PassWord=\\1${dbpass}/" /etc/odbc.ini

    #重启MYSQL并打开自动重启
    systemctl restart mysqld
    systemctl enable mysqld

    #清空操作记录
    cat /dev/null >/root/.mysql_history
    cat /dev/null >/root/.bash_history
}

# CentOS8.x安装
Install_8x(){
    if [ ! -f "/opt/tlbbfor8x.tar.gz" ];then
        wget -P /opt http://liebiao071.oss-cn-beijing.aliyuncs.com//tlbbfor8x.tar.gz
    fi
    tar zxvf /opt/tlbbfor8x.tar.gz -C /opt
    # 设置数据库密码
    read -p "请输入您需要设置的MySQL数据库密码: " dbpass;
    LimitIsTure=0
    while [[ "$LimitIsTure" == 0 ]]
    do
        if [[ "${#dbpass}" -ge 1 ]];then
            LimitIsTure=1
        else
            read -p "密码必须大于等于1位,请重新输入 : " dbpass;
        fi
    done

    # 进入安装目录
    cd /opt

    # 数据库安装
    yum -y remove mysql-libs
    tar zxvf MySQL.tar.gz
    rpm -ivh mysql-client.rpm --nodeps --force
    rpm -ivh mysql-server.rpm --nodeps --force

    # 数据库权限相关操作
    mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'root' with grant option;";
    mysql -e "use mysql;update user set password=password('${dbpass}') where user='root';";
    mysql -e "create database tlbb;";
    mysql -e "flush privileges;";

    # 配置ODBC
    sed -i "s/PassWord=123456/PassWord=\\1${dbpass}/" /etc/odbc.ini

    #重启MYSQL并打开自动重启
    systemctl restart mysqld
    systemctl enable mysqld

    #清空操作记录
    cat /dev/null >/root/.mysql_history
    cat /dev/null >/root/.bash_history
}

# 删档操作
DeleteData(){
    read -p "确定要执行删档操作吗？(y/n): " yn
    if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
        mysql -uroot -p${dbpass} -e "drop database tlbb;"
        mysql -uroot -p${dbpass} -e "create database tlbb;"
        echo "删档完成"
    else
        echo "已取消删档操作"
    fi
}

# 选择安装版本
read -p "请选择您要安装的版本(0-5): " num
case "$num" in
    0)
    Install_58
    ;;
    1)
    Install_65
    ;;
    2)
    Install_7x
    ;;
    3)
    Install_8x
    ;;
    4)
    DeleteData
    ;;
    5)
    exit
    ;;
    *)
    echo "请输入正确的数字(0-5)"
    ;;
esac
