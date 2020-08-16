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
                    nodejs(nodeJSInstallationName: 'Node 10.x') {
                    sh 'cd pixelistic_be && npm install'
                    sh '<<Build Command>>'   
            }                     
      }
    }  
    
            
    stage('Test') {
      steps {
        sh 'node test'
      }
    }
  }
}
