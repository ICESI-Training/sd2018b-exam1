cookbook_file '/home/vagrant/endpoint/scripts/deploy.sh' do
	source 'deploy.sh'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end


cookbook_file '/home/vagrant/endpoint/requirements.txt' do
	source 'requirements.txt'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end

cookbook_file '/home/vagrant/endpoint/gm_analytics/handlers.py' do
	source 'handlers.py'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end

cookbook_file '/home/vagrant/endpoint/gm_analytics/swagger/indexer.yaml' do
	source 'indexer.yaml'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end
