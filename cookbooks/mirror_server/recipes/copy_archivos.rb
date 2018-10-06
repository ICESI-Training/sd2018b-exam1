cookbook_file '/etc/ssh/sshd_config' do
    source 'sshd_config'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

cookbook_file '/home/vagrant/packages.json' do
    source 'packages.json'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

cookbook_file '/home/vagrant/install_packages.py' do
    source 'install_packages.py'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end
