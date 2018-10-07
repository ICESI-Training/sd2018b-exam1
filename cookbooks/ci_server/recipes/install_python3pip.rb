bash 'install_python3pip' do
	  code <<-EOH
       sudo yum install -y yum-utils
       sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
       sudo yum install -y python36u
       sudo yum install -y python36u-pip
       yum install -y python36u-devel.x86_64
			 pip install --upgrade pip
			 pip3.6 install connexion
			 pip3.6 install fabric
  	  EOH
end
