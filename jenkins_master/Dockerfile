FROM jenkins/jenkins:2.84
USER root
RUN groupadd docker \
  && addgroup jenkins docker
RUN apt-get update
RUN apt-get -y install python python-pip inotify-tools sudo \
    apt-transport-https ca-certificates curl gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \ 
    add-apt-repository \
   	"deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   	$(lsb_release -cs) \
   	stable" && \
    sudo apt-get update && \
    sudo apt-get install -y docker-ce && \
    rm -rf /var/lib/apt/lists/* && \
    pip install awscli && \
    mkdir -p /var/jenkins_home/updates && \
    curl -L https://updates.jenkins-ci.org/experimental/update-center.json | sed '1d;$d' > /var/jenkins_home/updates/experimental.json && \
    /usr/local/bin/install-plugins.sh \
      docker-slaves:1.0.6 \
      github-branch-source:2.0.5 \
      workflow-aggregator:2.5 \
      saml:0.13 \
      github:1.27.0 \
      junit:1.20 \
      matrix-auth:1.5 \
      role-strategy:2.4.0 \
      blueocean:1.0.1 \
      ansicolor:0.5.0 \
      timestamper:1.8.8 && \
    echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state && \
    rm -rf /var/jenkins_home/updates

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
COPY entry.sh /home/jenkins/entry.sh
RUN ["chmod", "777", "/home/jenkins/entry.sh"]
USER jenkins
ENTRYPOINT ["/home/jenkins/entry.sh"]