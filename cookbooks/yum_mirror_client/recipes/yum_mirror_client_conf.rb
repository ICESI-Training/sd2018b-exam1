bash 'yum_mirror_client_conf' do
    user 'root'
    code <<-EOH
        rm -rf /etc/hosts
    EOH
end
