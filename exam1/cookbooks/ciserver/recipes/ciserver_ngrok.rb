bash 'ciserver_update' do
  user 'root'
  code <<-EOH
  mkdir ngrok
  cd ngrok
  rm -rf ngrok-stable-linux-amd64.zip
  rm -rf ngrok
  wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
  unzip ngrok-stable-linux-amd64.zip
  EOH
end
