bash 'yum_mirror_server_config' do
    user 'root'
    code <<-EOH
        systemctl reload sshd.service
    EOH
end
