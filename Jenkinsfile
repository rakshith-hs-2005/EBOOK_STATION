pipeline {
    agent any

    stages {

        stage('Clone Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/rakshith-hs-2005/EBOOK_STATION.git'
            }
        }
stage('Install Dependencies') {
    steps {
        bat '"C:\\Program Files\\WindowsApps\\PythonSoftwareFoundation.Python.3.11_3.11.2544.0_x64__qbz5n2kfra8p0\\python3.11.exe" -m pip install -r requirements.txt'
    }
}

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t ebookstation .'
            }
        }

        stage('Run Container') {
            steps {
                bat 'docker run -d -p 5000:5000 --name ebookstation ebookstation'
            }
        }
    }
}