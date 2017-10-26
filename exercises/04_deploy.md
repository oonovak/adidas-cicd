## Deploying the Image

---

The final step in our pipeline is deploy, where we get our code running. We'll
use a Kubernetes cluster running on GCE for this purpose.

---

### Initial Deployment

First we need to deploy our application onto our cluster. For this we need to 
create a valid yml for kubernetes.

---

Inside the repo we cloned earlier there should be a file called `go-example-webserver.yml`, 
inside that file replace your docker hub user id for `<docker_hub_user_id>`.

---

Deploy it onto our cluster using the following command: 

```
kubectl apply -f go-example-webserver.yml
```

---

### Integrate Kubernetes into Jenkins

First we need to add our kubeconfig as a Jenkins credential. Following
instructions similar to our previous exercise add the kubeconfig file to Jenkins.

---

* Navigate to the Jenkins main page.
* From the navigation on the left select `Credentials`.
* Next select `System` which is below `Credentials`.
* Choose `Global credentials`.
* In the navigation on the left select `Add Credentials`.
* From the dropdown for `kind` select `Secret file`.
* Choose the kubeconfig file, and give an ID of `kubeconfig`
* Hit `OK` to save our changes

---

Now add the following stage to our `Jenkinsfile` after the `Push` stage:

```
    def K8S_DEPLOYMENT_NAME = 'go-example-webserver'

    stage("Deploy") 
    echo "Deploying image"
    docker.image('smesch/kubectl').inside{
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
            sh "kubectl --kubeconfig=$KUBECONFIG set image deployment/${K8S_DEPLOYMENT_NAME} ${K8S_DEPLOYMENT_NAME}=${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}"
        }
    }
```

---

The command above runs the sh command in a docker container that has kubectl,
it also includes the credential file we uploaded to Jenkins. 

Using withCredential allows us to access the file from within the container.

---

After committing and pushing these changes, you should be able to access the
running service in your browser using the `kubectl port-forward` command and port 8080.

```
$ kubectl get po
$ kubectl port-forward <pod-id> 8080
```

---

Now try making a change to the code, committing and pushing it. You should
quickly see the effects of your change - the `kubectl set image` command will
apply changes to our cluster.

Congratulations! You have a fully fledged Continuous Deployment pipeline up and
running.

---

## Bonus Task

Take a deeper look at how Kubernetes pods and services work. Try creating
multiple load-balanced instances of the image and seeing how they are updated
when the image is changed.

---

[Next up Provenance...](./05_provenance.md)
