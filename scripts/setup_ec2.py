import paramiko
import os

# --------- Configuration ----------
EC2_HOST = "YOUR_EC2_PUBLIC_IP"
USERNAME = "ubuntu"
KEY_PATH = "/home/ubuntu/.ssh/terraform-key.pem"  # Must have correct permissions (chmod 400)
REPO_URL = "https://github.com/DevOpsByOmer/Projects.git"
APP_DIR = "apps/backend-api/order-service"
ENV_VARS = {
    "FLASK_ENV": "production",
    "PORT": "5000"
}
# ----------------------------------

def setup_ec2():
    try:
        # Load SSH key
        key = paramiko.RSAKey.from_private_key_file(KEY_PATH)

        # Connect to EC2
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        print(f"Connecting to {EC2_HOST}...")
        ssh.connect(EC2_HOST, username=USERNAME, pkey=key)

        commands = [
            "sudo apt update -y",
            "sudo apt install -y git docker.io python3-pip",
            f"git clone {REPO_URL}",
            f"cd {APP_DIR} && pip3 install -r requirements.txt",
            f"echo \"FLASK_ENV={ENV_VARS['FLASK_ENV']}\" >> .env",
            f"echo \"PORT={ENV_VARS['PORT']}\" >> .env",
            f"cd {APP_DIR} && nohup python3 run.py &"
        ]

        for cmd in commands:
            print(f"Executing: {cmd}")
            stdin, stdout, stderr = ssh.exec_command(cmd)
            print(stdout.read().decode())
            err = stderr.read().decode()
            if err:
                print(f"Error: {err}")

        ssh.close()
        print("✅ EC2 setup completed.")
    except Exception as e:
        print(f"❌ Failed to setup EC2: {e}")

if __name__ == "__main__":
    setup_ec2()
