bash 'install_ngrok' do
          code <<-EOH
       mkdir /home/vagrant/ngrok
	     cd /home/vagrant/ngrok
       sudo wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
	     sudo unzip ngrok-stable-linux-amd64.zip
	     sudo rm -r ngrok-stable-linux-amd64.zip
          EOH
end
