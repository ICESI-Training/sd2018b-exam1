cookbook_file '/home/vagrant/endpoint.zip' do
	source 'endpoint.zip'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end
