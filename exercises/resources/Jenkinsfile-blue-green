node {
  def DOCKER_HUB_ACCOUNT = 'icrosby'
  def DOCKER_IMAGE_NAME = 'go-example-webserver'
  def K8S_DEPLOYMENT_NAME = 'go-example-webserver'
  def appName="go-webserver"
  def project=""
  def tag="blue"
  def altTag="green"

  project = env.PROJECT_NAME

  echo "Initializing..."
  stage("Initialize")
  docker.image('smesch/kubectl').inside{
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
            sh "kubectl --kubeconfig=$KUBECONFIG get ing ingress-blue-green -o json | jq '.spec.rules[2].http.paths[0].backend.serviceName' > activeservice"

            activeService = readFile('activeservice').trim()
            if (activeService == "${appName}-blue") {
              tag = "green"
              altTag = "blue"
            }

            sh "kubectl --kubeconfig=$KUBECONFIG get ing ingress-blue-green -o json | jq '.spec.rules[2].host' > deploy_route"
            deploy_route = readFile('deploy_route').trim()
       }
  }

  stage("build image")
  echo 'Building Docker image tag ${tag}'
  def app = docker.build "${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${tag}"

  stage("push")
  echo 'Pushing Docker Image'
  docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
    app.push()
  }

  stage("deploy") 
  echo "Deploying image"
  docker.image('smesch/kubectl').inside{
    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
      sh "kubectl --kubeconfig=$KUBECONFIG set image deployment/${K8S_DEPLOYMENT_NAME}-${tag} ${K8S_DEPLOYMENT_NAME}=${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}:${tag}"
    }
  }

  stage("manual test") {
    input message: "Test new deployment via: http://${deploy_route}/go. Approve?", id: "approval"
  }

  stage("go to production")
  echo "Deploying to Production"
  docker.image('smesch/kubectl').inside{
    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
        sh "kubectl --kubeconfig=$KUBECONFIG patch ing ingress-blue-green -p '{\"spec\":{\"rules\":[{\"host\": \"go-webserver.com\",\"http\":{\"paths\":[{\"backend\":{\"serviceName\":\"go-webserver-${tag}\",\"servicePort\":80}}]}},{\"host\": \"blue-go-webserver.com\",\"http\":{\"paths\":[{\"backend\":{\"serviceName\":\"go-webserver-blue\",\"servicePort\":80}}]}},{\"host\": \"green-go-webserver.com\",\"http\":{\"paths\":[{\"backend\":{\"serviceName\":\"go-webserver-green\",\"servicePort\":80}}]}}]}}'"
    }
  }
}