import os
import urllib.request

for file_name in os.listdir("_root"):
    os.rename(f"_root/{file_name}", f"../{file_name}")

urllib.request.urlretrieve("https://www.gitignore.io/api/django", "../.gitignore")
