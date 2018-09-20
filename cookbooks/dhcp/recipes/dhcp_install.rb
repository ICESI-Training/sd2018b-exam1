bash 'dhcp_install' do
  code <<-EOH
    yum -y intall dhcp
    EOH
  
end
