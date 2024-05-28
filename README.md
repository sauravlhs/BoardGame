### A Complete CICD Project
<img width="960" alt="1" src="https://github.com/sauravlhs/BoardGame/assets/67467237/bd8e42a7-4d9a-4676-8505-a4a3bb7f2d68">



1. Create a VPC where you want to build the project.
2. Create a Security Group for the EC2 instance.

   ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/ea55db13-b4a2-42f6-8e8b-48c36a5c1d73)
   
3. Create the required EC2 instance as below and attach the security group to it.
 
   ![image](https://github.com/sauravlhs/BoardGame/assets/67467237/08743e68-0bf6-43a7-9af0-d2ae9c523dcd)
   
4. Make sure you have downloaded the mobaXterm to access the EC2 instance through it.
5. Once you have accessed the instance, update the instance and download the required tools for the project.
6. Once all the tools are set up, Open jenkins -> Manage Jenkins -> Available plugins. Now download all the required plugins for the project.
   
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






    








