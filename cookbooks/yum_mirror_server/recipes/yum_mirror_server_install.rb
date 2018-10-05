bash 'yum_mirror_server_install' do
    user 'root'
    code <<-EOH
        cd /home/vagrant/packages
        python3.6 install_packages.py
    EOH
end
