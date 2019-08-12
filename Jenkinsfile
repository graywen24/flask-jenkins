node {
  def project = 'wenwen-1035'
  def appName = 'flask'
  def feSvcName = "my${appName}"
  def imageTag = "gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
  // def check = sh script: "kubectl get deployment --namespace jenkins|grep ${feSvcName}|awk '{print \$1}'", returnStdout: true


  checkout scm

  stage 'Build image'
  sh("docker build -t ${imageTag} .")

  stage 'Run tests'
  sh("docker images")

  stage 'Push image to registry'
  sh("gcloud docker -- push ${imageTag}")

  stage ('Deploy Application') {
  def check = sh script: "kubectl get deployment --namespace ${appName}|grep ${appName}|awk '{print \$1}'", returnStdout: true
 // String xyz = echo "${check}"
  // String abc = echo "my${appName}"
	//  #!/bin/bash
   // sh script: {
	//  if ( xyz.toUpperCase() == abc.toUppercase() ) {
	  if (check) {
        sh("kubectl set image deployment/${feSvcName} ${feSvcName}=${imageTag}")
	echo 'Successfully updated the deployment'
           } else {
    sh("kubectl run  ${feSvcName} --image=${imageTag} --port 80")
    sh("kubectl expose deployment ${feSvcName} --type=LoadBalancer --port=8080 --target-port=80")
    echo 'To access your environment run `kubectl get svc`'
      }
// }
  }
}