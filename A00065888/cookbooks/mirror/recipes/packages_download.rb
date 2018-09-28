cookbook_file '/home/vagrant/importweb_packages.py' do
  source 'process.py'
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end
