bash 'mirror_yum' do
  user 'root'
  code <<-EOH
  yum repolist
  yum update -y
  EOH
end
