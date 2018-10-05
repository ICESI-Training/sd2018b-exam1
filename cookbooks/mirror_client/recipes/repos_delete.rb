bash 'yum_update' do
  cwd '/etc/yum.repos.d'
  code <<-EOH
    rm -rf *
    EOH
end
