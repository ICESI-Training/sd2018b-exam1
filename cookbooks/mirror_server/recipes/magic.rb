cookbook_file '/home/vagrant/process.py' do
  source 'process.py'
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end



