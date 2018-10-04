bash 'python_install' do
	user 'root'
  code <<-EOH
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm
    yum install -y python36u python36u-libs python36u-devel python36u-pip
    pip install --upgrade pip
    pip3.6 install connexion
    pip3.6 install fabric
    EOH
  
end
