bash 'ciserver_update' do
  user 'root'
  code <<-EOH
  yum install -y epel-release
  yum install -y python36u
  yum install -y python36u-pip
  yum install -y wget
  yum install -y unzip
  mkdir exam1
  cd exam1
  pip3.6 install virtualenv
  virtualenv exam1
  source exam1/bin/activate
  pip3.6 install flask
  pip3.6 install fabric
  pip3.6 install requests
  cp /tmp/exam1.py exam1.py
  deactivate
  EOH
end
