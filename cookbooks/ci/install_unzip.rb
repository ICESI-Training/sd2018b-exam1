bash 'install_wget' do
  user 'root'
  code <<-EOH
  yum install unzip -y
  EOH
end
