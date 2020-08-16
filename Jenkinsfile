pipeline {
    agent { label 'master' }  
    
  stages {
        
    stage('Git') {
      steps {
        git 'https://github.com/gatalyak/pixelistic.git'
      }
    }
     
    stage('Build backend') {
      steps {
        dir('pixelistic_be'){
          sh 'npm install'
        }    
      }
    }  

    stage('Build frontend') {
      steps {
        dir('pixelistic_fe'){
          sh 'npm install'
        }    
      }
    }  
      
        stage('Tests'){
            steps {
                echo 'Executing tests'
            }
        }      

        stage('Deploy'){
            steps {
                dir('deployment'){
                    echo 'Deploying'
                    sh 'ansible-playbook -i dev-servers site.yml -u root'
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
