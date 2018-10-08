bash 'set_endpoint' do
	  code <<-EOH
	     mkdir /home/vagrant/install_endpoint
	     cd /home/vagrant/install_endpoint
	     mkdir instructions
	     mkdir gm_analytics
	     cd gm_analytics
	     mkdir swagger
  	  EOH
end

cookbook_file '/home/vagrant/install_endpoint/instructions/deploy.sh' do
	source 'ci_endpoint/instructions/deploy.sh'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end

cookbook_file '/home/vagrant/install_endpoint/gm_analytics/handlers.py' do
	source 'ci_endpoint/gm_analytics/handlers.py'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end

cookbook_file '/home/vagrant/install_endpoint/gm_analytics/swagger/indexer.yaml' do
	source 'ci_endpoint/gm_analytics/swagger/indexer.yaml'
	  owner 'root'
	  group 'root'
	  mode '0777'
	  action :create
end
