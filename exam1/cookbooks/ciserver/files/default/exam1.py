from flask import Flask, request, json
from fabric import Connection
import subprocess
import requests

app = Flask(__name__)

@app.route('/abc/exam1/api/v1/packages', methods=['POST'])
def set_packages():
    comm=Connection(host="root@192.168.180.40",connect_kwargs={"password":"vagrant"})
    content=request.get_data()
    string=str(content, 'utf-8')
    jsonFile=json.loads(string)
    sha=jsonFile["pull_request"]["head"]["sha"]
    packagesUrl="https://raw.githubusercontent.com/abc1196/sd2018b-exam1/"+sha+"/packages.json"
    packagesResponse=requests.get(packagesUrl)
    packages=json.loads(packagesResponse.content)
    packagesString=' '.join(packages["packages"])
    updateMirror="yum install --downloadonly --downloaddir=/var/repo "+packagesString
    comm.run("cd /var/repo")
    comm.run(updateMirror)
    comm.run("createrepo --update /var/repo/")
    return json.dumps(packages)


if __name__ == '__main__':
   app.run(debug=True)

