bash 'mirror_delete_repos' do
  cwd '/etc/yum.repos.d'
  code <<-EOH
  rm -rf *
  EOH
end
