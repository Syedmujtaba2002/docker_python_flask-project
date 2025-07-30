pipeline {
    agent any

    environment {
        APP_DIR = "/var/lib/jenkins/flaskapp"
        SERVICE_NAME = "flaskapp"
    }

    stages {
        stage('Clean Previous App') {
            steps {
                sh '''
                    sudo rm -rf ${APP_DIR}
                '''
            }
        }

        stage('Checkout Code') {
            steps {
                sh '''
                    git clone https://github.com/Syedmujtaba2002/docker_python_flask-project.git ${APP_DIR}
                '''
            }
        }

        stage('Install Python and Dependencies') {
            steps {
                sh '''
                    sudo apt update
                    sudo apt install -y python3 python3-venv
                '''
            }
        }

        stage('Setup Virtual Environment') {
            steps {
                sh '''
                    python3 -m venv ${APP_DIR}/venv
                    ${APP_DIR}/venv/bin/pip install -r ${APP_DIR}/requirements.txt
                '''
            }
        }

        stage('Create systemd Service') {
            steps {
                sh '''
                    SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
                    sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Flask App as a systemd Service
After=network.target

[Service]
User=jenkins
WorkingDirectory=${APP_DIR}
ExecStart=${APP_DIR}/venv/bin/python3 app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF
                '''
            }
        }

        stage('Start Flask App') {
            steps {
                sh '''
                    sudo systemctl daemon-reexec
                    sudo systemctl daemon-reload
                    sudo systemctl enable ${SERVICE_NAME}
                    sudo systemctl restart ${SERVICE_NAME}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Flask app deployed successfully!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}
