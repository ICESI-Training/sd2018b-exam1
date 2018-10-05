bash 'install_wget' do
  user 'root'
  code <<-EOH
  yum install wget -y
  EOH
end
