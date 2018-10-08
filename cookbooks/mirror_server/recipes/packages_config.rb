cookbook_file '/home/vagrant/package.json' do
  source 'package.json'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
