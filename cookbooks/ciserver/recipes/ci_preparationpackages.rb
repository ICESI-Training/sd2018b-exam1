bash 'ci_preparationpackages' do
  user 'root'
  code <<-EOH
  yum install unzip -y
  yum install wget -y
  EOH
  
end
