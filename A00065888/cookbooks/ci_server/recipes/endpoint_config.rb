bash 'endpoint_config' do
	  code <<-EOH
	     mkdir /home/vagrant/endpoint
	     cd /home/vagrant/endpoint
	     mkdir scripts
	     mkdir gm_analytics
	     cd gm_analytics
	     mkdir swagger
  	  EOH
end
