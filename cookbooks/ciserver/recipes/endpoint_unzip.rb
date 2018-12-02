bash 'endpoint_unzip' do
  user 'root'
  code <<-EOH
   cd /home/vagrant
   unzip endpoint.zip
   rm -rf endpoint.zip
  EOH
  
end
