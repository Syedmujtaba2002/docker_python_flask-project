#!/bin/bash

echo "🔁 Stopping systemd service"
sudo systemctl stop flaskapp.service || true

echo "📥 Updating project"
rm -rf /home/ubuntu/flaskapp
git clone https://github.com/Syedmujtaba2002/docker_python_flask-project.git /home/ubuntu/flaskapp

cd /home/ubuntu/flaskapp

echo "🔧 Setting up virtualenv"
sudo apt update -y
sudo apt install -y python3-venv
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "🧾 Creating systemd service file"
sudo bash -c 'cat > /etc/systemd/system/flaskapp.service <<EOF
[Unit]
Description=Flask App Service
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/flaskapp
ExecStart=/home/ubuntu/flaskapp/venv/bin/python app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

echo "🔁 Restarting systemd"
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl restart flaskapp

echo "✅ Flask App deployed and managed via systemd"
