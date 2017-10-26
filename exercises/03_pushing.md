## Pushing to a Registry

---

If an image succesfully passes the tests, the next step is to push it to a
registry. In our case we'll use Docker Hub, but this could be any local or
remote registry.

---

#### Add docker hub crendential to Jenkins

* Navigate to the Jenkins main page.
* From the navigation on the left select `Credentials`.
* Next select `System` which is below `Credentials`.
* Choose `Global credentials`.
* In the navigation on the left select `Add Credentials`.
* Fill out the `Username` and `Password` that you use for Docker Hub.
* In the `ID` field fill out `docker-hub` and hit `OK`.

---

Add the following to the `Jenkinsfile` after the `test image` stage:

```
    stage("Push")
    echo 'Pushing Docker Image'
    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
        app.push()
    }
```

---

Commit and push:
```
$ git commit -am "Update Jenkinsfile"
$ git push
```

This should trigger our pipeline within one minute.

---

## Bonus Task

1. Try pushing to self-hosted registry instead of the Docker Hub. You should be able to get one running by following the instructions at https://hub.docker.com/_/registry/.

---

[Next up Deploying...](./04_deploy.md)
