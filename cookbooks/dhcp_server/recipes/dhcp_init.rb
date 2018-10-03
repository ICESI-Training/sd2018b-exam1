bash 'dhcp_init' do
		user 'root'
	  code <<-EOH
	      systemctl start dhcpd.service
				systemctl eneable dhcpd.service
	  EOH
end
