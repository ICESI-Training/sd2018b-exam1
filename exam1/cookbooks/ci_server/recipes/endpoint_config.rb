bash 'endpoint_config' do
	  code <<-EOH
	     mkdir /home/vagrant/endpoint
	     cd /home/vagrant/endpoint
	     mkdir scripts
	     mkdir -p gm_analytics/swagger
			 EOH
end
