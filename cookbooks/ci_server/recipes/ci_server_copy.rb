cookbook_file '/home/vagrant/endpoint/scripts/deploy.sh' do
	source 'endpoint/scripts/deploy.sh'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end

cookbook_file '/home/vagrant/endpoint/requirements.txt' do
	source 'endpoint/requirements.txt'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end

cookbook_file '/home/vagrant/endpoint/gm_analytics/handlers.py' do
	source 'endpoint/gm_analytics/handlers.py'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end

cookbook_file '/home/vagrant/endpoint/gm_analytics/swagger/indexer.yml' do
	source 'endpoint/gm_analytics/swagger/indexer.yaml'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end
