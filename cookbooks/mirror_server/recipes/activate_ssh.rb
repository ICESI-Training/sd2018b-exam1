bash 'activate_ssh' do
  user 'root'
  code <<-EOH
  systemctl reload sshd.service
  EOH
end
