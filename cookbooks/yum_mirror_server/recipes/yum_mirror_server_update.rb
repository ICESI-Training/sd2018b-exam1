bash 'yum_mirror_server_update' do
    user 'root'
    code <<-EOH
        systemctl reload sshd.service
    EOH
end
