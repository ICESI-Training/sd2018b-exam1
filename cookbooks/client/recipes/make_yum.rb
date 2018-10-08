bash 'make_yum' do
  user 'root'
  code <<-EOH
  yum clean all
  yum update -y
  EOH
end
