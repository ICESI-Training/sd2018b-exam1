import urllib.request

# Download the file from `url` and save it locally under `file_name`:
with urllib.request.urlopen(url) as response, open(packages.json, 'wb') as out_file:
        data = response.read() # a `bytes` object
        out_file.write(data)
