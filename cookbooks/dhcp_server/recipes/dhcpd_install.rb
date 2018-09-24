bash 'yum_install_dhcp' do
	  code <<-EOH
	     yum install dhcp -y
  	  EOH
end
