pipeline {
    agent any

    environment {
        IMAGE_NAME = 'dreamacademy'
        TAG = "${env.GIT_COMMIT}" // Menggunakan commit hash sebagai tag
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'pwd' // Menampilkan direktori saat ini
                    // Membangun Docker image
                    sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Memeriksa apakah container dengan nama 'dreamacademy' sudah berjalan
                    sh """
                    if [ \$(docker ps -q -f name=dreamacademy) ]; then
                        docker stop dreamacademy
                        docker rm dreamacademy
                    fi
                    """
                    // Menjalankan container baru dengan port yang diekspos
                    sh "docker run -d -p 80:80 --name dreamacademy ${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }
}
