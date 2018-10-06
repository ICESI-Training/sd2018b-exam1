bash 'sshd_restart' do
  user 'root'
  code <<-EOH
  systemctl reload sshd.service
  EOH
end
