bash 'inst_ngrok' do
	  code <<-EOH
	     yum install -y https://centos7.iuscommunity.org/ius-release.rpm
	     yum install -y python36u
	     yum install -y python36u-pip
             yum install -y python36u-devel.x86_64
	     yum install -y wget
	     yum install -y unzip
	     pip install --upgrade pip
             pip3.6 install connexion
	     pip3.6 install fabric
  	  EOH
end
