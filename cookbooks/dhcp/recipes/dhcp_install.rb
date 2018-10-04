bash 'dhcp_install' do
  code <<-EOH
    yum -y install dhcp
    EOH
  
end
