bash 'dhcpd_install' do
  user 'root'
  cwd '/'
  code <<-EOH
  yum install dhcp -y
  EOH
end
