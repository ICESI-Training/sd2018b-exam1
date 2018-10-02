bash 'mirror_server_config' do
  user 'root'
  code <<-EOH
  yum update
  mkdir /var/repo
  cd /var/repo
  systemctl start httpd
  systemctl enable httpd
  yum install -y createrepo
  yum install -y yum-plugin-downloadonly
  yum install -y https://centos7.iuscommunity.org/ius-release.rpm
  yum install -y policycoreutils-python
  createrepo /var/repo/
  ln -s /var/repo /var/www/html/repo
  semanage fcontext -a -t httpd_sys_content_t "/var/repo(/.*)?" && restorecon -rv /var/repo
  EOH
end
