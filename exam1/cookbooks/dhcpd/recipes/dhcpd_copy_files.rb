cookbook_file '/etc/dhcp/dhcpd.conf' do
  source 'dhcpd.conf'
  owner 'root'
  group 'root'
  mode '0577'
  action :create
end
