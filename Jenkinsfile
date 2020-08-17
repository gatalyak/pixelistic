pipeline {
    agent { label 'master' }  

  environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        MONGO_DB = credentials('MONGO_DB')
        EMAIL_USER = credentials('EMAIL_USER')
        FRONT_URL = "${env.FRONT_URL}"      
  }  
  stages {
        
    stage('Git') {
      steps {
        git 'https://github.com/gatalyak/pixelistic.git'
      }
    }    
      
    stage('Build backend') {
      steps {
        dir('pixelistic_be'){
          sh 'npm ci --production'
        }    
      }
    }  

    stage('Build frontend') {
      steps {
        dir('pixelistic_fe'){
          sh 'npm install'
          sh 'npm run build'  
        }    
      }
    }  
      
        stage('Tests'){
            steps {
                echo 'Executing tests'
            }
        }      

        stage('SonarQube analysis'){
            steps {
                echo 'Executing SonarQube analysis'
            }
        }      
      
 
      
      
        stage('Deploy'){
            steps {
                dir('deployment'){
                    echo 'Deploying'
                    sh 'ansible-playbook -i dev-servers site.yml -u root --extra-vars \\\"EMAIL_PASS=${EMAIL_USER_PSW} EMAIL_USER=${EMAIL_USER_USR} FRONT_URL=${FRONT_URL} MONGO_DB=${MONGO_DB} AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \\\"' 
                }
            }
        }      
 
        stage('Healthcheck'){
            steps {
                echo 'Executing healthcheck'
            }
        }      
      
      
  }
}
