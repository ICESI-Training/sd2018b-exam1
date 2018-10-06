bash 'install_ngrok' do
	  code <<-EOH
	     mkdir /home/vagrant/ngrok
	     cd /home/vagrant/ngrok
	     wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
	     unzip ngrok-stable-linux-amd64.zip
	  EOH
end
