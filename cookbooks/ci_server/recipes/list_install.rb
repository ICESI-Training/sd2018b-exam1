bash 'list_install' do
  user 'root'
  code <<-EOH
  yum install unzip -y
  yum install wget -y
  yum install https://centos7.iuscommunity.org/ius-release.rpm -y
  yum install python36 python36u-pip -y
  yum install vim -y
  EOH
end
