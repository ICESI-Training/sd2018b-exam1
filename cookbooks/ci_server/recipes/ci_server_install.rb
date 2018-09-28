bash 'ci_server_install' do
		user 'root'
	  code <<-EOH
       yum install https://centos7.iuscommunity.org/ius-release.rpm -y
       yum install python36 python36u-pip -y
			 yum install wget -y
			 yum install unzip -y
			 pip3.6 install connexion
  	  EOH
end
