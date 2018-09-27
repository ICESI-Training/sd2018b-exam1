bash 'wget_install' do
	  code <<-EOH
        yum update -y
        yum install unzip -y
      EOH
end
