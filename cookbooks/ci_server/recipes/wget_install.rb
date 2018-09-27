bash 'unzip_install' do
	  code <<-EOH
        yum update -y
        yum install wget -y
      EOH
end
