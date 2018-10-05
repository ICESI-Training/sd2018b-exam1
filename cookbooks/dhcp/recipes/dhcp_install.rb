 bash 'dhcp_install' do
  user 'root'
  code <<-EOH
     yum install dhcp -y
    EOH
  
end
