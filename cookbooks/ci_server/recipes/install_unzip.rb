bash 'install_unzip' do
  user 'root'
  code <<-EOH
  yum install unzip -y
  EOH
end
