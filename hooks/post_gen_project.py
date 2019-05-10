import os
import urllib.request

urllib.request.urlretrieve("https://www.gitignore.io/api/django", "../.gitignore")

for file_name in os.listdir("_root"):
    os.rename(f"_root/{file_name}", f"../{file_name}")
os.rmdir("_root")

with open("../.env.example", "a+") as env_example:
    with open("../.env.example.docker", "r") as env_example_docker:
        env_example.write(env_example_docker.read())

os.remove("../.env.example.docker")
