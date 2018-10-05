bash 'yum_mirror_server_config' do
    user 'root'
    code <<-EOH
        mkdir /var/repo
        cd /var/repo
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        yum install -y createrepo
        yum install -y yum-plugin-downloadonly
        createrepo /var/repo/
        ln -s /var/repo /var/www/html/repo
        yum install -y policycoreutils-python
        semanage fcontext -a -t httpd_sys_content_t "/var/repo(/.*)?" && restorecon -rv /var/repo
        yum install -y openssh-server openssh-clients
        chkconfig sshd on
        service sshd start
        rm -rf /etc/ssh/sshd_config
        yum install https://centos7.iuscommunity.org/ius-release.rpm -y
        yum install python36 python36u-pip -y
        mkdir /home/vagrant/packages
    EOH
end
