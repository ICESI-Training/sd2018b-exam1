bash 'ci_server_conf' do
    user 'root'
    code <<-EOH
        cd /home/vagrant
        mkdir ngrok
        cd ngrok
        wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
        unzip ngrok-stable-linux-amd64.zip
        ./ngrok authtoken 63LNouz3BCPNwndPzTJXJ_37e96pM37TzqagbiXiEhZ
    EOH
end
