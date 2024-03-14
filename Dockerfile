FROM jenkins/jenkins 

USER root

RUN apt-get update && apt-get install -y lsb-release

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

RUN groupadd docker

RUN usermod -aG docker jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"



# ENTRYPOINT [ "/bin/sh","-c","service docker start && /sbin/tini -- /usr/local/bin/jenkins.sh" ]

# FROM jenkins/jenkins
 
# USER root

# RUN apt-get update -qq && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common

# RUN curl -fsSL download.docker.com/linux/debian/gpg | apt-key add -

# RUN add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/debian \
#    $(lsb_release -cs) \
#    stable"

# RUN apt-get update -qq && apt-get install -qqy docker-ce docker-ce-cli containerd.io

# RUN usermod -aG docker jenkins

# ENTRYPOINT ["/bin/sh", "-c", "service docker start && /sbin/tini -- /usr/local/bin/jenkins.sh"]