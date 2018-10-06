bash 'set_endpoint' do
	  code <<-EOH
	     mkdir /home/vagrant/scripts
	     mkdir /home/vagrant/gm_analytics
	     cd /home/vagrant/gm_analytics
	     mkdir swagger
  	  EOH
end

cookbook_file '/home/vagrant/requirements.txt' do
	source 'endpoint/requirements.txt'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end

cookbook_file '/home/vagrant/scripts/deploy.sh' do
	source 'endpoint/scripts/deploy.sh'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end

cookbook_file '/home/vagrant/gm_analytics/handlers.py' do
	source 'endpoint/gm_analytics/handlers.py'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end

cookbook_file '/home/vagrant/gm_analytics/swagger/indexer.yaml' do
	source 'endpoint/gm_analytics/swagger/indexer.yaml'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end
