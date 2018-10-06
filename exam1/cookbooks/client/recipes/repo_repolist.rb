bash 'repo_repolist' do
	user 'root'
	cwd '/'
	code <<-EOH
	 yum clean all
	 yum update -y
	 yum --disablerepo="*" --enablerepo="icesirepo" list available
	EOH
end
