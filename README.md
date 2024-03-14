
# Installing jenkins and portainer with docker

## compose-yml 
 ```yml
services:
  portainer:
    container_name: portainer
    image: portainer/portainer-ce
    ports:
      - 9000:9000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_volume:/data
  jenkins:
    container_name: jenkins
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - 8080:8080
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - jenkins_volume:/var/jenkins_home
   
volumes:
  portainer_volume:
  jenkins_volume:
 
```
## Creating a Dockerfile for Jenkins
Docker-in-Docker (DinD) refers to running Docker inside a Docker container. This allows running a Docker daemon within a container and using this daemon to create, run, and manage Docker containers. DinD is useful for scenarios where there is a need to use Docker inside containers, such as in development and testing environments.
https://www.jenkins.io/doc/book/installing/docker/
```dockerfile
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
```
## Run command
```bash
docker compose up
```

## localhost:8080 for Jenkins
Jenkins is an open-source automation server that helps automate the software development process, including building, testing, and deploying applications.

![1](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/4d909e3e-907d-477c-bf8e-81cccdbcb194)



## Use the following docker commands to get the initial password.
```bash
docker logs -f jenkins

#or

docker exec -it jenkins
ls /var/jenkins_home
cat secret.key
```


![Screenshot 2024-03-13 184042](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/64fcd030-58b9-4765-8540-d618536991ec)

![Screenshot 2024-03-13 184254](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/ee1e671e-aa0b-4d1a-82d2-3ea041f92de4)

![Screenshot 2024-03-13 184417](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/f374c18e-82ba-45b2-9b07-9bc7046bc6fb)

![Screenshot 2024-03-13 184450](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/e2ab0a8a-4c87-4436-80da-35ce36dbd5b6)

![Screenshot 2024-03-13 184458](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/0861eaf0-1528-4671-adb5-bffcd7687dea)

## Manage jenkins > Plugins > Available plugins > github
## Install Github Integration, Github Authentication and Generic Webhook Trigger for automate build container

![Screenshot 2024-03-13 210346](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/445e8703-6620-4df6-bdfc-37eff3bb1257)

![Screenshot 2024-03-13 210425](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/1da1739d-d03f-4649-a3b8-bb86b3c96510)

![Screenshot 2024-03-13 210432](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/b7721023-5fd8-416d-94dd-39adb7943d87)

## Restart your jenkins app

![Screenshot 2024-03-13 210509](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/c8513edf-7ddf-461a-8abd-372db7d77649)

![Screenshot 2024-03-13 210710](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/8067f44f-3581-4e80-9acb-86ff3dddc275)

## Create a new item

![Screenshot 2024-03-13 234038](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/45b43f38-df7a-4b5f-a598-33bfc6ce3f0f)


### Select GitHub, paste your GitHub repository project and specify the branch being used.

![Screenshot 2024-03-13 234235](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/960d1bb0-dd3a-4dcf-8d34-6844e968c8c6)

![Screenshot 2024-03-13 234236](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/7d68b089-4a65-46b4-a6da-f4ed84bdcb3e)






### If you want it to be built automatically upon committing, check the 'GitHub hook trigger' option and configure the GitHub project's webhook.

![Screenshot 2024-03-13 234302](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/cdc7efa8-050d-4666-a278-87a66340be42)

### Settings > Webhooks > Add Web hook

![Screenshot 2024-03-14 183208](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/994fa677-080e-428b-ba99-10f020598b60)

## Select 'Execute Shell' in the build steps and type your Docker commands.

![Screenshot 2024-03-13 234311](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/5d84e846-b44d-40f6-9508-35051740e959)


### If the Docker Compose file is located in another folder, use 'docker compose -f ./folder/compose-yml'. Otherwise, if it's in the same folder, use 'docker compose'.

--build: This option is used to rebuild images each time Docker Compose is executed, ensuring that the latest changes are reflected in the images.

--force-recreate: This option is used to recreate running containers, allowing changes made in the Docker Compose file to take effect.

![Screenshot 2024-03-13 234312](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/11381ac0-16a0-4abd-b291-69654ba30b80)


### If you check the 'GitHub hook trigger' option, the project will be automatically built upon committing. 
### Unless, pressing the 'Build Now' button will build your project.


![Screenshot 2024-03-13 234409](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/f79fb47c-c72c-461c-b4f4-235052223445)

![Screenshot 2024-03-13 235947](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/88f2c057-9815-4502-b79d-1a82cf5f18ad) | ![Screenshot 2024-03-14 000422](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/a0691b9a-d33a-4702-9e16-2e7b3b83e48d)

### Build History > #1 > Click the 'Console Output' for logs

![Screenshot 2024-03-14 000450](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/448e2c8d-3d22-40a2-81ec-b66185fd77eb)


## localhost:9000 for portainer

Portainer is an open-source interface and management tool for Docker and Kubernetes, providing users with an easy-to-use web interface to manage containerized applications.

![Screenshot 2024-03-13 190024](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/ce6c3099-e3dd-4a84-b16e-e8ee55cfaa8b)

![Screenshot 2024-03-13 190154](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/43df9da5-7c97-46cf-bc7f-2ba247fd83fd)


![Screenshot 2024-03-13 190208](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/94f50d8f-d129-4aa9-8bfd-a079a1b9313f)


![Screenshot 2024-03-13 190219](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/583cd506-ef40-497e-9623-d0bd616ea621)


## Use Portainer to manage Docker containers, allowing you to start, stop, and perform other actions within Docker.

![Screenshot 2024-03-13 190251](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/61d34a67-d556-4426-ae1e-d867e0b7dc8b)


![Screenshot 2024-03-14 000115](https://github.com/mstf-yalcin/docker-portainer-jenkins/assets/83976212/b3e1d051-6737-4428-b178-60929ab0818c)











