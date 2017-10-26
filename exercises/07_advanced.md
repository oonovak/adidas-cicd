## Advanced 
## Deployments
## with Kubernetes

---

Let's look at how we can do some advanced deployments with Jenkins and Kubernetes. Specifically we will look at Blue/Green deployments.

---


A **Blue/Green** deployment differs from a standard ramped deployment because the <font color=green>green</font> version of the application is deployed alongside the <font color=blue>blue</font> version. 

After verifying the new version, we update the our load balancer to send traffic to the new version.

---

Let's setup a pipeline which will alternate between `green` and `blue` deployments, with a manual **approval** step. 

---

## Ingress

In order to expose our applications externally (from our cluster) we will need to use a feature of Kubernetes called **ingress** 

---

### What is ingress?

Typically, services and pods have IPs only routable by the cluster network. All traffic that ends up at an edge router is either dropped or forwarded elsewhere. Conceptually, this might look like:
```
    internet
        |
  ------------
  [ Services ]
```
An Ingress is a collection of rules that allow inbound connections to reach the cluster services.
```
    internet
        |
   [ Ingress ]
   --|-----|--
   [ Services ]
```

---

Ingress can be configured to:
* Give services externally-reachable urls
* Loadbalance traffic
* Terminate SSL
* Offer name based virtual hosting

---

### Ingress controller

In order for the Ingress resource to work, the cluster must have an `Ingress Controller` running.

An `Ingress Controller` is a daemon, deployed as a Kubernetes Pod, that watches the ApiServer's /ingresses endpoint for updates to the Ingress resource. Its job is to satisfy requests for ingress.

---


REMOVE THIS


Let's make sure we already have an ingress controller:

```
$ kubectl get pods -n kube-system -l name=nginx-ingress-controller
```

---

We will need to create two services and deployments for this scenario. 

You can find these defined in this repo under `./exercices/resources/`

Be sure to replace the <DOCKER_USER> with your user id, then deploy them to the cluster

```
$ kubectl apply -f services.yaml
$ kubectl apply -f deployments.yaml
```

---

Verify the deployments are working via:

```
$ kubectl get pods
```

---

The last piece we need to deploy is the Ingress routes, take a look at the 
provided ingress file: `./exercices/resources/ingress.yaml`

```
$ kubectl apply -f ./exercices/resources/ingress.yaml
```

---

View the Jenkinsfile under ./exercises/resources/Jenkinsfile-blue-green

There are some additional stages added here, such as `Initialize` `Manual Test` and 'Go To Production'

Walkthrough the file and add the necessary pieces to your existing Jenkinsfile.

---

## Run the new pipeline

Once you commit the changes, watch the output of the pipeline, you should reach the Manual Test stage which will prompt for manual testing.

Of course we do not own the domain 'go-webserver.com' so, in order to test the application we will need to use `curl` or a browser plugin to modify the host header. With curl we can do something like:

```
curl -H 'blue-go-webserver.com' 'http://<HOST_IP>/go' 
```

---

Now, make a small change to the application, e.g. change the returned text

```
...
	w.Write([]byte("Hello From Adidas"))
...
```

(N.B. You will need to adjust the test as well.)

---

Commit your code change and trigger the pipeline. Test and approve the new version.

---


Let's look at the Pros and Cons of this style of deployment

Pros:

* instant rollout and rollback
* avoid versioning issue, change the entire cluster state at once

Cons:

* requires double the resources (during deployments)
* proper test of the entire platform should be done before releasing to production
* handling stateful applications can be tricky