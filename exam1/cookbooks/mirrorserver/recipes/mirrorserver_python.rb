python 'mirrorserver_python' do
  user 'root'
  code <<-EOH
import json

#prompt the user for a file to import
with open('/vagrant/packages.json', 'r') as theFile:
       jsonFile=json.load(theFile)
       packages= ' '.join(jsonFile["packages"])
       file=open("/vagrant/packages.txt", "w")
       file.write(packages)
       file.close()
  EOH
end
