pipeline {
    agent { label 'master' }  
    
  stages {
        
    stage('Git') {
      steps {
        git 'https://github.com/gatalyak/pixelistic.git'
      }
    }
     
    stage('Build') {
      steps {
        dir('pixelistic_be'){
          sh 'npm install'

        }    
      }
    }  
              
  }
}
