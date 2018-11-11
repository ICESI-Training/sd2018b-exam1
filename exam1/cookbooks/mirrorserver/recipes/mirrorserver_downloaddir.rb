bash 'mirrorserver_downloaddir' do
  user 'root'
  code <<-EOH
  PACKAGES=$( cat /vagrant/packages.txt )
  yum install --downloadonly --downloaddir=/var/repo $PACKAGES
  createrepo /var/repo/
  ln -s /var/repo /var/www/html/repo
  yum -y install policycoreutils-python
  semanage fcontext -a -t httpd_sys_content_t "/var/repo(/.*)?" && restorecon -rv /var/repo
  rm -rf /vagrant/packages.json
  rm -rf /vagrant/packages.txt
  EOH
end
