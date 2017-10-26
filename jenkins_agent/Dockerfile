FROM jenkinsci/slave:latest
USER root

# Install GoLang

ENV GO_VERSION 1.8.4

RUN curl -sSL https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz -o /tmp/go.tar.gz && \
    CHECKSUM=0ef737a0aff9742af0f63ac13c97ce36f0bbc8b67385169e41e395f34170944f && \
    echo "${CHECKSUM}  /tmp/go.tar.gz" | sha256sum -c - && \
    tar -C /usr/local -vxzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go:/go/src/app/_gopath

RUN mkdir -p /go/src/app /go/bin && chmod -R 777 /go

RUN ln -s /go/src/app /app
WORKDIR /go/src/app
  
LABEL go_version=$GO_VERSION

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
    rm -rf /var/lib/apt/lists/*

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN sudo mv ./kubectl /usr/local/bin/kubectl


RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER jenkins