bash 'set_endpoint' do
	  code <<-EOH
	     mkdir /home/vagrant/request_handler
	     cd /home/vagrant/request_handler
	     mkdir scripts
	     mkdir gm_analytics
	     cd gm_analytics
	     mkdir swagger
  	  EOH
end

cookbook_file '/home/vagrant/request_handler/requirements.txt' do
	source 'endpoint/requirements.txt'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end

cookbook_file '/home/vagrant/request_handler/scripts/deploy.sh' do
	source 'endpoint/scripts/deploy.sh'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end

cookbook_file '/home/vagrant/request_handler/gm_analytics/handlers.py' do
	source 'endpoint/gm_analytics/handlers.py'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end

cookbook_file '/home/vagrant/request_handler/gm_analytics/swagger/indexer.yaml' do
	source 'endpoint/gm_analytics/swagger/indexer.yaml'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end
