import paramiko
import time

# Configuration
host = "13.200.250.186"
user = "ubuntu"  # Use "ec2-user" for Amazon Linux
key_path = "terraform-key.pem"  # Make sure this is created in the workflow or locally
docker_image = "saotech/order-service:latest"
container_name = "order-service"
app_port = 5000

# Commands to run on the EC2 instance
commands = [
    "echo '🔧 Updating packages and installing Docker...'",
    "sudo apt-get update -y",
    "sudo apt-get install -y docker.io",
    "sudo usermod -aG docker $USER",
    "newgrp docker",
    
    f"echo '📦 Pulling Docker image: {docker_image}'",
    f"docker pull {docker_image}",
    
    f"echo '🧹 Cleaning up old container (if exists)'",
    f"docker rm -f {container_name} || true",

    f"echo '🚀 Running Docker container {container_name}'",
    f"docker run -d -p {app_port}:{app_port} --name {container_name} {docker_image}",

    f"echo '🩺 Running health check...'",
    f"curl -f http://localhost:{app_port} || echo '⚠️ App may not be responding'"
]

def run_remote_commands(host, user, key_path, commands):
    print(f"📡 Connecting to EC2 at {host}...")
    try:
        key = paramiko.RSAKey.from_private_key_file(key_path)
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname=host, username=user, pkey=key)

        for cmd in commands:
            print(f"\n➡️ Executing: {cmd}")
            stdin, stdout, stderr = ssh.exec_command(cmd)
            time.sleep(1)
            output = stdout.read().decode()
            error = stderr.read().decode()
            if output:
                print(f"✅ OUTPUT:\n{output}")
            if error:
                print(f"❌ ERROR:\n{error}")
        ssh.close()
        print("\n✅ EC2 Setup & Deployment Completed Successfully.")
    except Exception as e:
        print(f"❌ Failed to setup EC2: {e}")

run_remote_commands(host, user, key_path, commands)
