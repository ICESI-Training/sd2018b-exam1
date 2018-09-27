cookbook_file '/etc/dhcp/dhcpd.conf' do
  source 'dhcpd.conf'
  mode '0440'
  owner 'root'
  group 'root'
  action :create

end
service 'dhcp' do
  action [:start, :enable]
end
