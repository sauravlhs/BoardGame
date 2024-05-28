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
   - After running the command, we can access the host using http://IP:8081
   - Now we need to change the password for Nexus which you can do by following the steps.
   - Execute `docker exec` to access the container's bash terminal
     ```bash
      docker exec -it <container_ID> /bin/bash
     ```
     Replace the <container_ID> with your Nexus container ID
   - Navigate to Nexus Directory inside the container's bash shell, and navigate to the directory where Nexus stores its configuration:

    ```bash
    cd sonatype-work/nexus3
    ```
    
   - View the content of `admin.password` file

    ```bash
    cat admin.password
    ```
    
   - exit bash by typing `bash`

6. **Setting up SonarQube**
   - Create a new file for the script eg. `sonarQube.sh` and paste the below command:
     
     ```bash
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
   - Now we will run sonarQube in Docker with the below command.
     
     ```bash
      docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
     ```

   - Access the sonarQube via `http://VmIP:9000`

7. **Configuring Jenkins**
   - Enter your login user id and password.
   - Click on install the suggested plugins.
   - Now go to Manage Jenkins --> available plugins.
   - Install the required plugins for the project.
  
     ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/01bdcfea-f8a5-43fb-9539-b15aee3f3156)

8. **Configuring Nexus repository**
   - Open Nexus via VM IP.
   - Go to Nexus --> Administration --> Configuration --> Webhooks.
   - Give the Webhooks name of your choice eg `Jenkins`.
   - In the URL section, enter SonarQube IP address in the following way `http://SonarQubeIP:8080/sonarqube-webhooks`.
   
   ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/1e63ba8c-7fd5-402c-b0bf-2048306cecb8)

9. **Setting Up GitHub repository**
   - Login to GitHub repository using your credentials.
   - Create a new Git repository.
   - We will copy the Git access token, for this we will go to settings --> Developer settings --> generate a new token by providing all the access and copy the token.
   - Clone the repository in your local by using the following command.
     ```bash
     git clone <your repository url>
     ```
     Replace `your repository URL` with your repository URL
   - Add your source code and run the following command:
    
     ```bash
     git add .
     git status
     git commit -m "your commit message"
     git push
     ```
     
   - If this is your first commit then you might need to specify the remote and branch as below:
     
     ```bash
     git push -u origin master
     ```
     
10. **Updating pom.xml file for Nexus Repository**
   - Open pom.xml file in the editor of your choice.
   - Open Nexus Repository on the web via VM IP.
   - Copy the IP address of maven-releases and maven-snapshots and update the pox.xml in the end as below:
     
     ```bash
        <distributionManagement>
           <repository>
         		<id>maven-releases</id>
         		<url>http://SonarQube IP/repository/maven-releases/</url>
         	</repository>
         	<snapshotRepository>
         		<id>maven-snapshots</id>
         		<url>http://SonarQube IP/repository/maven-snapshots/</url>
         	</snapshotRepository>
      	</distributionManagement>
     ```

   ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/a5db0165-5dfe-46e9-9819-7739b260547c)



11. **Setting up Nexus repository in Jenkins**
    - Go to Jenkins --> Manage Jenkins --> Open manage files --> Click on add a new config --> select global maven settings.xml.
    - Give ID of your choice and click next.
    - Find the Content section and scroll down until you find Servers section.
    - Add the following section:
      
      ```bash
      <server>
         <id>maven-releases</id>
         <username>your SonarQube username</username>
         <password>your SonarQube password</password>
      </server>
      <server>
         <id>maven-snapshots</id>
         <username>your SonarQube username</username>
         <password>your SonarQube password</password>
      </server>
      ```
    
   - Click on Submit.


![image](https://github.com/sauravlhs/BoardGame/assets/67467237/e295911c-55f2-4961-8920-4e5dd6e27a21)

12. **Configuring required tools in Jenkins**
    - Go to Jenkins dashboard --> Manage Jenkins --> tools
    
     Maven
    - In name give `maven3`.
    - Select Install Automatically.
    - click on the dropdown and select `3.6.1`.

     JDK
    - Go to JDK section
    - In the name section give name as `jdk17`.
    - Select Install Automatically.
    - click on the dropdown and select `jdk-17.0.9+9`.

     SonarQube
    - Go to SonarQube Scanner installations section
    - In the name section give name as `sonar-scanner`.
    - Select Install Automatically.
    - click on the dropdown and select `SonarQube Scanner 5.0.1.3006`.

     Docker
    - Go to Docker installation section
    - In the name section give name as `docker`.
    - Select Install Automatically and select add installer.
    - Select download from Docker.com.
   
    
13. **Setting up new pipeline**
    - Go to Jenkins Dashboard.
    - Select New Item.
    - Give the project name of your choice eg. `BoardGame`, select pipeline, and click Ok.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/aba85d1b-3b94-4718-8246-0eb3f666c51c)

    - In General section select discard old builds.
    - In max # of builds to keep enter `2`.
    - Scroll down to the pipeline section and select pipeline script.
   
14. **Creating on pipeline script**
    - Below is the pipeline script.
      
      ```bash
      pipeline {
       agent any
   
       tools{
           jdk 'jdk17'
           maven 'maven3'
       }
       
       environment {
           SCANNER_HOME= tool 'sonar-scanner'
       }
   
       stages {
           stage('Git Checkout') {
               steps {
                  git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/sauravlhs/BoardGame.git'
               }
           }
           stage('Compile') {
               steps {
                   sh "mvn compile"
               }
           }
           stage('Test') {
               steps {
                   sh "mvn test"
               }
           }
           stage('File system scan') {
               steps {
                   sh "trivy fs --format table -o trivy-fs-report.html ."
               }
           }
           stage('SonarQube Analysis') {
               steps {
                   withSonarQubeEnv('sonar'){
                       sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame -Dsonar.projectKey=BoardGame -Dsonar.java.binaries=. '''
                   }
               }
           }
           stage('Quality Gate') {
               steps {
                   waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
               }
           }
           stage('Build') {
               steps {
                   sh "mvn package"
               }
           }
           stage('Publish to Nexus') {
               steps {
                   withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                         sh "mvn deploy"
                   }
               }
           }
           stage('Build and Tag Docker image') {
               steps {
                   script{
                       withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                           sh "docker build -t sauravlhs/cicdproject:latest ."
                        
                    }
                }
            }
        }
        stage('Docker Image Scan') {
            steps {
                sh "trivy image --format table -o trivy-image-report.html sauravlhs/cicdproject:latest"
            }
        }
        stage('push docker image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker push sauravlhs/cicdproject:latest"
                        
                    }
                }
            }
        }
        stage('Deploy to kubernetes') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.7.67:6443') {
                    sh "kubectl apply -f deployment-service.yml"
                }
            }
        }
        stage('Verify the deployment') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.7.67:6443') {
                    sh "kubectl get pods"
                    sh "kubectl get svc"
                }
            }
        }
        
       }
      }
     
      ```
15. **Deploying application to kubernetes cluster**

     Creating Service Account, Role & Assing the role

     - Creating a service account
       - create a new file eg. `service.yml` and paste the below command:
       
       ```bash
       apiVersion: v1
       kind: ServiceAccount
       metadata:
       name: jenkins
       namespace: webapps
       ```

       - run the file by using the below command
         ```bash
         kubectl apply -f service.yml
         ```

      - Creating a role
        - create a new file eg. `role.yml` and paste the below command:
   
        ```bash
         apiVersion: rbac.authorization.k8s.io/v1
         kind: Role
         metadata:
         name: app-role
         namespace: webapps
         rules:
         - apiGroups:
         - ""
         - apps
         - autoscaling
         - batch
         - extensions
         - policy
         - rbac.authorization.k8s.io
         resources:
         - pods
         - componentstatuses
         - configmaps
         - daemonsets
         - deployments
         - events
         - endpoints
         - horizontalpodautoscalers
         - ingress
         - jobs
         - limitranges
         - namespaces
         - nodes
         - pods
         - persistentvolumes
         - persistentvolumeclaims
         - resourcequotas
         - replicasets
         - replicationcontrollers
         - serviceaccounts
         - services
         verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
        ```

        - run the file by using the below command
         ```bash
         kubectl apply -f role.yml
         ```

      - Assigning the role to service account
        - create a new file eg. `bind.yml` and paste the below command:
        
        ```bash
         apiVersion: rbac.authorization.k8s.io/v1
         kind: RoleBinding
         metadata:
         name: app-rolebinding
         namespace: webapps
         roleRef:
         apiGroup: rbac.authorization.k8s.io
         kind: Role
         name: app-role
         subjects:
         - namespace: webapps
         kind: ServiceAccount
         name: jenkins
        ```

        - run the file by using the below command
         ```bash
         kubectl apply -f bind.yml
         ```

      Generating a token for using the service account in namespace
    
      - Create a new file eg. `secret.yml` and paste the below command:
        
        ```bash
         apiVersion: v1
         kind: Secret
         type: kubernetes.io/service-account-token
         metadata:
           name: mysecretname
           annotations:
             kubernetes.io/service-account.name: jenkins
        ```
        
        - run the file by using the below command
          
         ```bash
         kubectl apply -f secret.yml -n webapps
         ```
      - Run the below command and copy the token from the output
        ```bash
        kubectl describe mysecretname -n webapps
        ```

      

      

    
17. **Setting up credentials for pipeline**
    - Go to Jenkins Dashboard --> Manage Jenkins --> Credentials --> select Global and Add Credentials
   
     GitHub
    - In kind section select `Username with password`.
    - In scope select `Global`.
    - In username, give your GitHub username.
    - In password give git token.
    - Give ID and description of your choice eg. `git-cred`.
    - Click on create.

     SonarQube
    - Go to Sonarqube --> Administration --> security --> tokens --> set the expiry date and click on generate.
    - Copy the generated token.
    - Now to go Jenkins --> manage jenkins --> credentials --> select Global and Add Credentials
    - In kind section select `Secret text`.
    - In scope select `Global`.
    - In secret, paste the secret key
    - Give ID and description of your choice eg. `sonar-token`.
    - Click on create.




18. Go to Jenkins Dashboard -> Manage Jenkins -> Credentials -> select Global and Add Credentials.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/ce56b258-9c4c-4cb3-bb4b-89294a0851e1)

19. Click on Build now.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/b754b802-0220-4136-b968-31860323db69)

20. Once your pipeline is built successfully. It will create an artifact and push it to nexus repository and the code vulnerability will be checked by SonarQube.

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/73d44577-9c97-4c93-98a5-3950019e545d)

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/5badc558-910c-456c-9bc5-03b93dad7b11)

21. Now we will set up Grafana dashboard. We will download Prometheus and Grafana dashboard.
22. Open Grafana dashboard -> data source -> add Prometheus URL and save. You will be able to see the dashboard

    ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/141c3226-e95e-4fd1-9756-6ff674754731)






    








