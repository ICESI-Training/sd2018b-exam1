bash 'ci_server_endpoint_conf' do
    user 'root'
    code <<-EOH
        pip3.6 install connexion
        pip3.6 install fabric
        pip3.6 install pygithub
        cd /home/vagrant
	      mkdir endpoint
	      cd endpoint
	      mkdir scripts
	      mkdir gm_analytics
	      mkdir gm_analytics/swagger
    EOH
end
