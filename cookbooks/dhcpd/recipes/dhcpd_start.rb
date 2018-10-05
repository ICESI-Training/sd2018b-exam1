bash 'dhcpd_install' do
  user 'root'
  cwd '/'
  code <<-EOH
	systemctl enable dhcpd.service
  	systemctl start dhcpd.service
  EOH
end
