bash 'install_packages' do
  user 'root'
  code <<-EOH
  cd /home/vagrant
  python process.py
  EOH
end


