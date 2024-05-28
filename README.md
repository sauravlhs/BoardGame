# A Complete CICD Project
<img width="960" alt="1" src="https://github.com/sauravlhs/BoardGame/assets/67467237/bd8e42a7-4d9a-4676-8505-a4a3bb7f2d68">

### Creating and EC2 Instance
1. **Sign in to your AWS account using your credentials**
   - Search EC2 instance and click on Launch Instance.
   - Choose Amazon Machine Image(AMI), Select Ubuntu server 20.04 LTS.
   - Configure the instance such as network settings, IAM role.
   - Next, add storage.
   - Add a security group as below.

   ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/5490a5d2-2748-46de-9d2f-a3b9ec52cb5b)

   - Click on Review and Launch.
   - Access your instance using MobaXterm.

2. **Setting up K8**
   - Update System packages [On Master & Worker Node]
     
     ```bash
     sudo apt-get update
     ```
     
   - Create a script to install Docker, required dependencies for Kubernetes, Add Kubernetes Repository and GPG Key, update the package, and install Kubernetes Components [On Master & Worker Node]
   - Create a new file eg. `k8.sh` 
   - paste the below command
     
     ```bash
     sudo apt install docker.io -y
     sudo chmod 666 /var/run/docker.sock

     sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
     sudo mkdir -p -m 755 /etc/apt/keyrings
      
     curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
     echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
     
     sudo apt update

     sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1
     
     ```
     
   - Make it executable using:
     
     ```bash
     chmod +x k8.sh
     ```
     
   - Now you can run it using:
     
     ```bash
     ./k8.sh
     ```
     
   - Initialize Kubernetes Master Node [On MasterNode]

     ```bash
     sudo kubeadm init --pod-network-cidr=10.244.0.0/16
     ```

   - Configure Kubernetes Cluster [On MasterNode]

     ```bash
     mkdir -p $HOME/.kube
     sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
     sudo chown $(id -u):$(id -g) $HOME/.kube/config
     ```
3. **Setting up Jenkins**
   - Update System packages [On Master & Worker Node]
     
     ```bash
     sudo apt-get update
     ```
   - Create a script to install Jenkins in Ubuntu
   - Create a new file eg. `Jenkins.sh`
   - Paste the command
      ```bash
      #!/bin/bash
      
      # Install OpenJDK 17 JRE Headless
      sudo apt install openjdk-17-jre-headless -y
      
      # Download Jenkins GPG key
      sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
        https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
      
      # Add Jenkins repository to package manager sources
      echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
        https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
        /etc/apt/sources.list.d/jenkins.list > /dev/null
      
      # Update package manager repositories
      sudo apt-get update
      
      # Install Jenkins
      sudo apt-get install jenkins -y
      ```
   - Make it executable using:
     
     ```bash
     chmod +x jenkins.sh
     ```
     
   - Now you can run it using:
     
     ```bash
     ./jenkins.sh
     ```

   - Now Install docker for future use. We will create a script for this and make it executable as done before.
   - Create a new file eg. `dock.sh` and paste the below command
     
     ```bash
     #!/bin/bash
      
     # Update package manager repositories
     sudo apt-get update
      
     # Install necessary dependencies
     sudo apt-get install -y ca-certificates curl
      
     # Create directory for Docker GPG key
     sudo install -m 0755 -d /etc/apt/keyrings
      
     # Download Docker's GPG key
     sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      
     # Ensure proper permissions for the key
     sudo chmod a+r /etc/apt/keyrings/docker.asc
      
     # Add Docker repository to Apt sources
     echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      
     # Update package manager repositories
     sudo apt-get update
      
     sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 
     ```
     
4. **Setting up Nexus**
   - Create a new file for script eg. `nexus.sh` and paste the below command
     
     ```bash
      #!/bin/bash
      sudo apt-get update
      
      # Install necessary dependencies
      sudo apt-get install -y ca-certificates curl
      
      # Create directory for Docker GPG key
      sudo install -m 0755 -d /etc/apt/keyrings
      
      # Download Docker's GPG key
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      
      # Ensure proper permissions for the key
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      
      # Add Docker repository to Apt sources
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      
      sudo apt-get update
      
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 
     ```
   - Make the file as executable and run the file as done before.
   - Now we will create a Nexus using Docker container by running nexus3 and exposing post 8081 by using the following command
     
     ```bash
      docker run -d --name nexus -p 8081:8081 sonatype/nexus3:latest
     ```
   - Now run `docker ps` tp get the container ID.
   - After running the command, we can access the host using HTTP://IP:8081
   - Now we need to change the password for Nexus which you can do by following the steps.
   - Execute `docker exec` to access the container's bash terminal
     ```bash
      docker exec -it <container_ID> /bin/bash
     ```
     Replace the <container_ID> with your Nexus container ID 
     



6. **Setting up SonarQube**
     









 
   
   

   
![image](https://github.com/sauravlhs/BoardGame/assets/67467237/d5c63c2a-bc49-4504-89a7-5922398fab9e)

7. Now download sonarQube, Nexus, and docker and set it up.
8. Once these are downloaded, go to Nexus -> Administration -> Configuration -> Webhooks and add the SonarQube URL
   
   ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/1e63ba8c-7fd5-402c-b0bf-2048306cecb8)

9. Once this is set, clone the GitHub URL into your repository https://github.com/sauravlhs/BoardGame.git
10. Open the Nexus Repository, and copy the link for Nexus releases and Nexus snapshots. Now open the pom.xml file and update the links as below.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/b74373c3-ebdb-4b90-a34d-0a388d312d95)

11. Go to Jenkins -> Manage Jenkins -> Open Manage Files -> Click on add a new config -> select global maven settings.xml -> give ID of your choice and click next -> scroll down the servers and change the configuration as per the pom.xml file and save it.

![image](https://github.com/sauravlhs/BoardGame/assets/67467237/e295911c-55f2-4961-8920-4e5dd6e27a21)

12. Go to Jenkins Dashboard -> Tools -> Configure Maven, JDK, SonarQube, Docker, 

13. Now go to Jenkins dashboard -> Select new Item -> give project name and select pipeline and click Ok.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/aba85d1b-3b94-4718-8246-0eb3f666c51c)


14. Select discard old builds and maximum last builds to 2. Scroll down to the pipeline section and select pipeline script. 

     ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/06df155d-9bc0-4ce2-975d-5a67b96663b6)

15. Create your pipeline according to the project. Apply and Save.
16. Go to Jenkins Dashboard -> Manage Jenkins -> Credentials -> select Global and Add Credentials.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/ce56b258-9c4c-4cb3-bb4b-89294a0851e1)

17. Click on Build now.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/b754b802-0220-4136-b968-31860323db69)

18. Once your pipeline is built successfully. It will create an artifact and push it to nexus repository and the code vulnerability will be checked by SonarQube.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/73d44577-9c97-4c93-98a5-3950019e545d)

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/5badc558-910c-456c-9bc5-03b93dad7b11)

19. Now we will set up Grafana dashboard. We will download Prometheus and Grafana dashboard.
20. Open Grafana dashboard -> data source -> add Prometheus URL and save. You will be able to see the dashboard

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/141c3226-e95e-4fd1-9756-6ff674754731)






    








