bash 'mirror_repo' do
	user 'root'
	cwd '/'
	code <<-EOH
	yum update
  mkdir /var/repo
  cd /var/repo
  yum install -y httpd
  systemctl enable httpd
  systemctl start httpd
  yum install -y createrepo
  yum install -y yum-plugin-downloadonly
	yum install -y https://centos7.iuscommunity.org/ius-release.rpm
  yum install -y policycoreutils-python
  createrepo /var/repo/
  ln -s /var/repo /var/www/html/repo
  semanage fcontext -a -t httpd_sys_content_t "/var/repo(/.*)?" && restorecon -rv /var/repo
	EOH
end
