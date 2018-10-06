bash 'packages_install' do
  user 'root'
  code <<-EOH
  cd /home/vagrant/
  python setup.py
  EOH
end
