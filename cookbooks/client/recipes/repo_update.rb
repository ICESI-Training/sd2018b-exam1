bash 'repo_update' do
  user 'root'
  code <<-EOH
  yum repolist
  yum update -y
  EOH
end
