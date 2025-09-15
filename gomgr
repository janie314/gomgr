#!/usr/bin/env python
import os
import subprocess
import tarfile
import requests
import shutil

# 1. Get current Go version if installed
go_path = shutil.which("go")
current_go_version = None
if go_path:
    try:
        result = subprocess.run(
            ["go", "version"], capture_output=True, text=True, check=True
        )
        version_output = result.stdout.strip().split()
        if len(version_output) >= 3:
            current_go_version = version_output[2]
            print(f"Go is already in PATH. Current version is: {current_go_version}")
        else:
            print("Found 'go' in PATH, but couldn't parse its version.")
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("Found 'go' in PATH, but couldn't execute 'go version'.")
else:
    print("Go is not in PATH. Proceeding with installation.")

# 2. Get the latest Go version from the Go development site
try:
    response = requests.get("https://go.dev/dl/?mode=json")
    response.raise_for_status()
    res = response.json()
    latest_go_version = res[0]["version"]
    print(f"Latest Go version available is: {latest_go_version}")
except (requests.exceptions.RequestException, IndexError, KeyError) as e:
    print(f"Error fetching latest Go version: {e}")
    latest_go_version = None

# 3. Check if Go needs to be installed or updated
if not go_path or (current_go_version and current_go_version != latest_go_version):
    if not go_path:
        print("Go is not installed. Installing the latest version.")
    else:
        print("A newer version of Go is available. Upgrading now.")

    if not latest_go_version:
        print("Could not determine the latest Go version. Aborting installation.")
    else:
        # Define installation paths
        home_dir = os.path.expanduser("~")
        local_bin_dir = os.path.join(home_dir, ".local", "bin")
        godir = os.path.join(local_bin_dir, "godir")

        # a. Create the destination directory
        os.makedirs(godir, exist_ok=True)

        # b. Download and extract the latest Go version
        download_url = f"https://go.dev/dl/{latest_go_version}.linux-amd64.tar.gz"
        print(f"Downloading from {download_url}")

        try:
            download_response = requests.get(download_url, stream=True)
            download_response.raise_for_status()

            with tarfile.open(fileobj=download_response.raw, mode="r:gz") as tar:
                tar.extractall(path=godir, filter="data")
            print("Download and extraction complete.")

            # c. Create symlinks
            go_symlink_src = os.path.join(godir, "go", "bin", "go")
            go_symlink_dst = os.path.join(local_bin_dir, "go")

            gofmt_symlink_src = os.path.join(godir, "go", "bin", "gofmt")
            gofmt_symlink_dst = os.path.join(local_bin_dir, "gofmt")

            for src, dst in [
                (go_symlink_src, go_symlink_dst),
                (gofmt_symlink_src, gofmt_symlink_dst),
            ]:
                if os.path.exists(dst):
                    os.remove(dst)
                os.symlink(src, dst)
                print(f"Created symlink: {dst} -> {src}")

            print("\nInstallation successful! 🚀")
            print(
                f"Make sure {local_bin_dir} is in your PATH. You may need to restart your terminal."
            )

        except (requests.exceptions.RequestException, tarfile.TarError, OSError) as e:
            print(f"An error occurred during installation: {e}")

else:
    print("Go is already the latest version. No action needed. ✨")
