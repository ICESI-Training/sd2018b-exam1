bash 'dhcp_install' do
  user 'root'
  code <<-EOH
    yum -y install dhcp
  EOH
  
end
