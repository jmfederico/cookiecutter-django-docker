"""Actions to be run after a successful Cookie bake."""
import os

for file_name in os.listdir("_root"):
    os.rename(f"_root/{file_name}", f"../{file_name}")
os.rmdir("_root")
