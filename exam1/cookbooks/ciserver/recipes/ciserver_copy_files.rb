cookbook_file '/tmp/exam1.py' do
  source 'exam1.py'
  owner 'root'
  group 'root'
  mode '0577'
  action :create
end
