FROM centos:7

# 1. 修复 yum 源
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && \
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo && \
    yum clean all && yum makecache
# 2. 安装缺失的基础环境（32位库、perl、ps等）
RUN yum clean all && yum makecache && \
    yum update -y libcurl && \
    yum install -y glibc.i686 libstdc++.i686 perl procps wget tar libcurl.i686 && \
    ln -sf /usr/lib/libcurl.so.4 /usr/lib/libcurl.so.3 && \
    ldconfig

# 3. 下载并安装老版本的 MySQL 库
RUN cd /tmp && \
    wget https://cdn.mysql.com/Downloads/MySQL-5.0/mysql-5.0.96-linux-i686-glibc23.tar.gz && \
    tar -zxf mysql-5.0.96-linux-i686-glibc23.tar.gz --strip-components=2 -C /lib/ mysql-5.0.96-linux-i686-glibc23/lib/libmysqlclient.so.15* && \
    ldconfig && \
    rm -rf /tmp/mysql-5.0*

CMD ["/bin/bash", "-c", "tail -f /dev/null""]
