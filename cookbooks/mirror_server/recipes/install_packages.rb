bash 'install_packages' do
    user 'root'
    code <<-EOH
    cd /home/vagrant
    python install_packages.py
    EOH
end
