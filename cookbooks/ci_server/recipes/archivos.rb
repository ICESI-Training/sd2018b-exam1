cookbook_file '/tmp/servicio.py' do
  source 'servicio.py'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
