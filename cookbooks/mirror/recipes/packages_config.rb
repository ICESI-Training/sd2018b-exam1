cookbook_file '/home/vagrant/packages.json' do
  source 'packages.json'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
