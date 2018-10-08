cookbook_file '/etc/ssh/sshd_config' do
	source 'sshd'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  action :create
end
