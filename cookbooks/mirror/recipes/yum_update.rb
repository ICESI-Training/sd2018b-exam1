bash 'yum_update' do
  user 'root'
  code <<-EOH
    yum clean all
    yum update -y
  EOH
  
end
