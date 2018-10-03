bash 'repo_repolist' do
	user 'root'
	cwd '/'
	code <<-EOH
	 yum repolist
	 yum update -y
	EOH
end
