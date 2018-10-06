bash 'install_tools' do
  user 'root'
  code <<-EOH
  yum install wget -y
  yum install unzip -y
  EOH
end
