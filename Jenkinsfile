
/* refer to https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app
*/

def project = 'wen-wen-1035'
def  appName = 'hello-app'
def  feSvcName = "${appName}-frontend"
def  imageTag = "gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"

pipeline {
  agent {
    kubernetes {
      label 'hello-app'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: cd-jenkins
  containers:
  - name: golang
    image: golang:1.10
    command:
    - cat
    tty: true
  - name: gcloud
    image: gcr.io/cloud-builders/gcloud
    command:
    - cat
    tty: true
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    command:
    - cat
    tty: true
"""
}
  }
  stages {
    stage('Test') {
      steps {
        container('golang') {
          sh """
            echo "==== here is TEST==="

          """
        }
      }
    }
    stage('Build and push image with google cloud Container Builder') {
      when {
        not { branch 'dev' }
      }
      steps {
        container('gcloud') {
          sh "PYTHONUNBUFFERED=1 gcloud builds submit -t ${imageTag} ."
        }
      }
    }
    stage('Deploy Staging') {
      // staging branch
      when { branch 'staging' }
      steps {

      }
    }
    stage('Deploy Production') {
      // Production branch
      when { branch 'master' }
      steps{
        container('kubectl') {
        // Change deployed image in canary to the one we just built
          sh("kubectl create deployment ${appName} --image=imageTag")
          echo "==show current pods=="
          sh("kubectl get pods")
          sh("kubectl expose deployment ${appName} --type=LoadBalancer --port 8080 --target-port 8080")
          sh("kubectl  get service/${appName} -o jsonpath='{.status.loadBalancer.ingress[0].ip}' > ${publicip} ")
          echo 'To access your environment http://${publicip}:8080'
        }
      }
    }
    stage('Deploy Dev') {
      // Developer Branches
      when {
        not { branch 'master' }
        not { branch 'staging' }
      }
      steps {
          echo ' here is only display for DEV'
        }
      }
    }
 }
