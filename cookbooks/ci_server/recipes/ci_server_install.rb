bash 'ci_server_install' do
	  code <<-EOH
       yum install -y https://centos7.iuscommunity.org/ius-release.rpm
			 yum update -y
       yum install -y python36 python36u-pip
  	  EOH
end
