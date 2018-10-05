cookbook_file '/home/vagrant/setup.py' do
  source 'setup.py'
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end
