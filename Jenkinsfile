pipeline {
    agent any

    stages {

        stage('Clone Code') {
            steps {
                git 'https://github.com/your-username/library-system.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'pip install -r requirements.txt'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t library-system .'
            }
        }

        stage('Run Container') {
            steps {
                bat 'docker run -d -p 5000:5000 library-system'
            }
        }
    }
}