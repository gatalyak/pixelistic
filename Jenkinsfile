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
                    nodejs(nodeJSInstallationName: 'Node 6.x', configId: '<config-file-provider-id>') {
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
