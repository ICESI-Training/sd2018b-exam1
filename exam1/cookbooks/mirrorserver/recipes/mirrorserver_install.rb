bash 'mirrorserver_install' do
  user 'root'
  code <<-EOH
  service sshd restart
  yum install -y createrepo
  yum install --downloadonly --downloaddir=/var/repo wget
  yum install -y wget
  yum install -y yum-plugin-downloadonly
  yum install -y https://centos7.iuscommunity.org/ius-release.rpm
  wget https://raw.githubusercontent.com/abc1196/sd2018b-exam1/abueno/exam1/packages.json -O /vagrant/packages.json
  EOH
end
