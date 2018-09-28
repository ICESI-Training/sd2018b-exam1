bash 'dhcp_init' do
  user 'root'
  cwd '/'
  code <<-EOH
  yum install dhcp -y
  #systemctl start dhcpd.service
  EOH
end
