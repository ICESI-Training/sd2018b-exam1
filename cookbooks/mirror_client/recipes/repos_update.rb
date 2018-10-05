bash 'yum_update' do
  code <<-EOH
    yum clean all
    yum repolist
    yum update -y
    EOH
  
end

