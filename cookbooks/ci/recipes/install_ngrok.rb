bash 'install_ngrok' do
          code <<-EOH
	     cd /home/vagrant
             wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
	     unzip /path/to/ngrok.zip
	     rm -r ngrok-stable-linux-amd64.zip
          EOH
end

