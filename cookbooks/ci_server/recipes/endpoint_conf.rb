bash 'ci_server_install' do
    user 'root'
    code <<-EOH
        pip3.6 install connexion
        cd /home/vagrant
	mkdir endpoint
	cd endpoint
	mkdir scripts
	mkdir gm_analytics
	mkdir gm_analytics/swagger
    EOH
end
