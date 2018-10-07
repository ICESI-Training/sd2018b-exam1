bash 'install_ngrok' do
	  code <<-EOH
       mkdir /home/vagrant/apps
			 mkdir /home/vagrant/apps/ngrok
       cd /home/vagrant/apps/ngrok
       wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
       unzip ngrok-stable-linux-amd64.zip
  	EOH
end
