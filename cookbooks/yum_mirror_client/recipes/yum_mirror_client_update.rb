bash 'yum_mirror_client_conf' do
    user 'root'
    code <<-EOH
        yum repolist
        yum update -y
        yum --disablerepo="*" --enablerepo="icesirepo" list available
    EOH
end
