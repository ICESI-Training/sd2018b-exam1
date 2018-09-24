bash 'yum_update' do
  code <<-EOH
    yum clean all
    yum update -y
    EOH
  
end
