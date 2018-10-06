cookbook_file '/etc/dhcp/dhcpd.conf' do
  source 'dhcpd.conf'
  mode '0644'
  owner 'root'
  group 'root'
  action :create

end
