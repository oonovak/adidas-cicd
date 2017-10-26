# Setup Jenkins


---

### First Steps

We'll be using your laptop for these exercises.

You'll need three things:

* GitHub account (_https://github.com_) 
* Docker Hub account(_https://hub.docker.com_)
* Docker 1.12+

---

Start by forking the repository located <a href="https://github.com/ContainerSolutions/go-example-webserver" target="_blank">here</a>.

Once you've done this, checkout the code on your
local laptop with `git clone`. 

We'll come back to the code later, but the next step is to get Jenkins up and
running on the VM. 

---
 
Run

```
$ docker run -d -p '8081:8080' -p '50000:50000' -v '/var/run/docker.sock:/var/run/docker.sock' icrosby/jenkins-master:latest
```
 
Create a file named `docker-compose.yml` with the
following contents:

```
version: '3'  
services:  
  master:
    image: icrosby/jenkins-master:latest
    # build: ./jenkins_master
    volumes:
     - /var/run/docker.sock:/var/run/docker.sock
    ports:
     - "8081:8080"
     - "50000:50000"
    restart: always

```

You can also grab this file via the following command

```
curl -sSL -o docker-compose.yml https://raw.githubusercontent.com/ContainerSolutions/go-example-webserver/master/jenkins-compose.yml
```


---


We can now start Jenkins:

```
$ docker-compose up -d
Creating network "continuousdeliverywithjenkins_default" with the default driver
Creating continuousdeliverywithjenkins_master_1 ...
Creating continuousdeliverywithjenkins_master_1 ... done
```

You should be able to view Jenkins by opening a browser and visiting
http://127.0.0.1:8081

---

You will need to enter the Administrator password to unlock Jenkins. You can find this via the logs from the Jenkins master:

```
$ docker-compose logs master
...
master_1    | *************************************************************
master_1    | *************************************************************
master_1    | *************************************************************
master_1    |
master_1    | Jenkins initial setup is required. An admin user has been created and a password generated.
master_1    | Please use the following password to proceed to installation:
master_1    |
master_1    | [PASSWORD]
master_1    |
master_1    | This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
master_1    |
master_1    | *************************************************************
master_1    | *************************************************************
master_1    | *************************************************************
...
```

---

Next we will need to install the necessary plugins. Select the manual option and remove all, except for:
  - Git Plugin
  - GitHub Plugin

Afterwards you will be prompted to create an Admin user (don't lose the password).

---

### Creating a Jenkins Job

Once Jenkins has restarted is up and running let's create our first pipeline.


---

- Select 'New Item' -> Pipeline
- Give the Pipeline a name
- Build Triggers:
  - Poll SCM
    - Schedule: `* * * * *    #Cron task`
- Under the Pipeline section, select:
  - Definition: `Pipeline script from SCM`
  - SCM: Git
  - Repository URL `https://github.com/[YOUR_GITHUB_ID]/go-example-webserver.git` 

---

### Build Triggers

Here we use a cron task which checks our repo once a minute. This is not a 'production ready' setup.
We can use the `H` hash function to spread out periodic checks. 

E.g. H/15 * * * * will check every 15 minutes, but not exactly at :15 :30: 45 

Even better we can setup hooks in GitHub which will notify Jenkins (we will do this in a later exercise).

---

## Running the Pipeline

Save the item, and select 'Build Now' To verify your build runs successfully.

We can check the logs via 'Console Output'


---

Looking at the Jenkinsfile, we can see this builds our source code and tests it.

What if we want to build an image using our Dockerfile instead?

---

Add a new stage to the Jenkinsfile:

```
  def DOCKER_HUB_ACCOUNT = '<docker-hub-username>'
  def DOCKER_IMAGE_NAME = 'go-example-webserver'

  echo 'Building Docker image'
  stage('BuildImage') 
  def app = docker.build("${DOCKER_HUB_ACCOUNT}/${DOCKER_IMAGE_NAME}", '.')
```

Commit and push the change. This should trigger the pipeline within one minute.

---

## Bonus Task

The Dockerfile for this project uses a single image for both building and running the application.
Another approach is to split this into two steps, so that the binary is built in
one stage, then copied into a new image that is used to run the application. The
advantage of this approach is that the final image can be much smaller, as it
doesn't require all the build files and tools from the first image. 

---

See if you can turn the build into a two stage process, using an alpine image as
the base for the final image (hint `docker create` and `docker cp` are your
friends). Once you've done this, see if you can take it even further and run the
webserver using the empty "scratch" image as a base.

---

[Next up Testing...](./02_testing.md)
