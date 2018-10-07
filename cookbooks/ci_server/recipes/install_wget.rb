bash 'install_wget' do
	  code <<-EOH
	     sudo yum install -y wget
  	  EOH
end
