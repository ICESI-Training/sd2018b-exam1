bash 'yum_mirror_client_update' do
    user 'root'
    code <<-EOH
        yum clean all
        yum repolist
        yum update -y
        yum --disablerepo="*" --enablerepo="icesirepo" list available
    EOH
end
