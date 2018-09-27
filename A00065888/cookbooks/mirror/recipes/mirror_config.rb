bash 'mirror_repo' do
	user 'root'
	cwd '/'
	code <<-EOH
	  yum install createrepo -y
	  yum install yum-plugin-downloadonly -y
	EOH
end
