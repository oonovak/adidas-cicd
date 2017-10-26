## Provenance 
## and Labeling

---

A major improvement we can make to the current system is using labels and tags
to add meaningful metadata about the image.

The first, and biggest, problem is that we've implicitly used the "latest" tag
when building our image. The most striking problem with this is that it makes
rolling back difficult or impossible, as the previous image had exactly the same
name. 

---

Some common variables used for tagging include the build number or the commit hash. 
There are many configuration settings made available by Jenkins as environment variables:

* BUILD_NUMBER
* BUILD_ID
* JOB_NAME
* GIT_COMMIT
* BUILD_TAG

A complete list can be found [here](https://wiki.jenkins.io/display/JENKINS/Building+a+software+project#Buildingasoftwareproject-JenkinsSetEnvironmentVariables)

---

Choose an appropriate variable and update your Jenkinsfile to add a TAG to the `Build Image` stage.

Hint: Docker images have the format `username/reponame[:tag]`

Note that you will also need to update subsequent stages in the pipeline.

---

## Going to Production

What about when we want to deploy our application to production? It can be useful to tag specific releases or stable builds.

We can use the `docker tag` command to tag an existing image.

---

Try adding steps to the the `Deploy` stage of the pipeline to tag the existing image with `production` and push it to Docker Hub.

Hint: the docker tag command has the format:

```
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
```

---

## Update the Deploy command

Finally update the `kubectl` command to pull the new `production` tagged image.

Run the pipeline and validate that the proper image tag is deployed.

---

Finally, we can also add some labels by updating the `Build Image` stage.

Labels are essentially metadata we can add to our images. They can be passed in to the
`docker build` command like so:

```
docker build --label build-date="$(date)" -t my-image:v1 
```

---

## Try it out

* Add the BUILD_NUMBER, GIT_COMMIT, and DATE as labels to your build.
* Run the image locally and use the `docker inspect` command on the running container.

You should be able to see the new metadata on the image - this sort
of information can be invaluable in debugging.

---

## Bonus Task

We would also like to be certain that gets built is exactly the same one that
gets deployed. As things stand, it's possible for someone to push a new image
in-between stages or tampering to occur in transit without our knowledge.
(cont.)

---

To guard against this, we can use Docker `digests` to verify the content of
images and to ensure we use the same image throughout. Update the `Jenkinsfile`
so that after pushing the image, the digest is extracted and saved to file. This
can then be picked up by the deploy stage and used as the argument to `docker
pull`. The `docker tag` tool can then be used to set the tag to the one used in
the `kubectl set image` command. Alternatively, you can look into updating the image by
using `docker service` commands rather than `docker stack deploy` and using the
digest explicitly.

---

[Next up DIY...](./06_diy.md)

