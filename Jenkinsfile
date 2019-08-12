
/* refer to https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app
*/

def PROJECT_ID = 'wen-wen-1035'
def  appName = 'hello-app'
def  feSvcName = "${appName}-frontend"
def  imageTag = "gcr.io/${PROJECT_ID}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"

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
      steps{ 
        echo "test only"
      }
        }
     
    stage('Deploy Production') {
      // Production branch
      when { branch 'master' }
      steps{
        container('kubectl') {
        sh("kubectl get pods")
        // Change deployed image in canary to the one we just built
          sh("kubectl get deployment ${appName}&&kubectl delete deployment ${appName} && kubectl delete service ${appName} &&sleep 40s  || kubectl create deployment ${appName} --image=gcr.io/${PROJECT_ID}/hello-app:v1")
          echo "==show current pods=="
          sh("kubectl get pods")
          sh("kubectl expose deployment ${appName} --type=LoadBalancer --port 8080 --target-port 8080")
          sh("echo http://`kubectl  get service/${appName} -o jsonpath='{.status.loadBalancer.ingress[0].ip}'` ")
       
        }
      }
    }  
  }
 }
