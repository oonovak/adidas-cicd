#!/bin/bash

echo "test"
sudo chown :docker /var/run/docker.sock

/bin/sh -c "/bin/bash -- /usr/local/bin/jenkins.sh"
