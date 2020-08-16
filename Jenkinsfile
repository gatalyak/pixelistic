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
      
      
      
      
  }
}
