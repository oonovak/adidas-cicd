
## Do It Yourself

Now that you've absorbed all this knowledge, it's time to try it out!

Create a simple application in your favourite language and use Docker, Jenkins and Kubernetes to build and test it. Consider trying a multi-stage build approach to avoid
bundling build artifacts into the final image. If you use Java, try using the
JDK base image to build a jar, and the JRE image to run it.

---

## Decoupling

Ideally we would like to avoid too much logic inside the Jenkinsfile (this tying us to the tool). 

As such let's create individual scripts for each step (build.sh, test.sh, deploy.sh), move the logic inside the script and call them from the Jenkinsfile.

---

[Next up Bonus: Advanced Deployments...](./07_advanced.md)