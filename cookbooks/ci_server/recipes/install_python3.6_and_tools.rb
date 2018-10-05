bash 'install_python3.6_and_tools' do
	     user 'root'
	     code <<-EOH
	     yum install -y https://centos7.iuscommunity.org/ius-release.rpm
			 yum install -y python36u
			 yum install -y python36u-pip
			 yum install -y python36u-devel.x86_64
	     pip3.6 install --upgrade pip
       pip3.6 install connexion fabric
  	  EOH
end
