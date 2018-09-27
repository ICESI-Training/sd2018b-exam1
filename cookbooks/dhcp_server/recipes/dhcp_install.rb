bash 'dhcp_install' do
	  code <<-EOH
			 yum update -y
	     yum install dhcp -y
  	  EOH
end
