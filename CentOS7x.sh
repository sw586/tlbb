# CentOS7.x安装
Install_7x(){
    # 检查网络连通性
    ping -c 1 google.com > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "网络不通，请检查您的网络连接。"
        exit 1
    fi

    # 检查并下载所需文件
    if [ ! -f "/opt/tlbbfor7x.tar.gz" ]; then
        wget -P /opt http://liebiao071.oss-cn-beijing.aliyuncs.com/tlbbfor7x.tar.gz || { echo "文件下载失败"; exit 1; }
    fi
    tar zxvf /opt/tlbbfor7x.tar.gz -C /opt || { echo "解压失败"; exit 1; }

    # 设置数据库密码
    read -p "请输入您需要设置的MySQL数据库密码: " dbpass
    while [[ ${#dbpass} -lt 1 ]]; do
        read -p "密码必须大于等于1位，请重新输入: " dbpass
    done

    # 进入安装目录
    cd /opt || { echo "无法进入指定目录"; exit 1; }

    # 数据库安装
    yum -y remove mysql-libs
    tar zxvf MySQL.tar.gz
    rpm -ivh mysql-client.rpm --nodeps --force
    rpm -ivh mysql-server.rpm --nodeps --force

    # 数据库权限相关操作
    mysql -e "grant all privileges on *.* to 'root'@'%' identified by 'root' with grant option;"
    mysql -e "use mysql;update user set password=password('${dbpass}') where user='root';"
    mysql -e "create database tlbbdb;"
    mysql -e "create database web;"
    mysql -e "flush privileges;"

    # 导入数据库
    mysql -uroot -p"${dbpass}" tlbbdb < tlbbdb.sql || { echo "导入tlbbdb失败"; exit 1; }
    mysql -uroot -p"${dbpass}" web < web.sql || { echo "导入web失败"; exit 1; }

    # 安装依赖组件
    sudo yum -y install glibc.i686 libstdc++ libstdc++.so.6

    # 安装ODBC与相关依赖
    tar zxvf lib.tar.gz
    rpm -ivh unixODBC-libs.rpm --nodeps --force
    rpm -ivh unixODBC-2.2.11.rpm --nodeps --force
    rpm -ivh libtool-ltdl.rpm --nodeps --force
    rpm -ivh unixODBC-devel.rpm --nodeps --force

    # 安装MYSQL ODBC驱动
    tar zxvf ODBC.tar.gz
    ln -s /usr/lib64/libz.so.1 /usr/lib/lib
    rpm -ivh mysql-odbc.rpm --nodeps --force

    # ODBC配置
    tar zvxf Config.tar.gz -C /etc
    chmod 644 /etc/my.cnf
    sed -i "s/^\(Password        = \).*/\1${dbpass}/" /etc/odbc.ini

    # 解压ODBC支持库到/usr/lib目录
    tar zvxf odbc.tar.gz -C /usr/lib
}
