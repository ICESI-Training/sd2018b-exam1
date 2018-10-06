bash 'mirror_packages' do
  user 'root'
  code <<-EOH
  cd /home/vagrant
  python importweb_packages.py
  EOH
end
