Standard Operating Procedure (SOP): Jenkins Automated CI/CD Pipeline for WordPress Docker Project
1. Introduction
This SOP provides detailed steps to set up a Jenkins CI/CD pipeline for automating the deployment of a WordPress Docker project hosted on AWS EC2. It includes test scenarios, CloudFormation integration, blogging automation, and S3 uploads.
2. Prerequisites

1. AWS Resources:
   - EC2 instance for Jenkins setup.
   - S3 bucket for storing build artifacts or blog uploads.
   - IAM role with permissions for Jenkins to interact with S3 and AWS services.
2. Docker Installed on Jenkins server to execute Docker-based builds.
3. CloudFormation Template to deploy AWS infrastructure.
4. GitHub Repository containing the WordPress Docker project.

3. Jenkins Installation and Configuration
Step 1: Install Jenkins

1. SSH into your EC2 instance (used for Jenkins).
   
Step 1: Install Java 17 or Newer
For Ubuntu or Debian-Based Systems
1.	Update your package list:
sudo apt update
2.	Install OpenJDK 17:
sudo apt install openjdk-17-jdk -y
3.	Verify the installation:
java -version
You should see an output indicating Java 17 is installed, such as:
openjdk version "17.x.x" ...
________________________________________
Step 2: Set Java 17 as the Default Version
1.	Configure the system to use Java 17:
sudo update-alternatives --config java
2.	Select the Java 17 option from the list of available versions.
3.	Verify the current default Java version:
java -version
Ensure Java 17 is now the default version.
Remove the Existing Jenkins Repository
Clean up the existing repository configuration:
sudo rm /etc/apt/sources.list.d/jenkins.list
2. Add the Jenkins GPG Key Using the Correct Method
The apt-key command is deprecated, so we use the new method to add the GPG key:
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
3. Add the Jenkins Repository
Add the repository with the keyring specified:
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
4. Update the Repository Index
Update the package list to reflect the new repository:
sudo apt update
5. Install Jenkins
Install Jenkins:
sudo apt install jenkins -y
6. Verify Installation
Start Jenkins and verify its status:
sudo systemctl start jenkins
sudo systemctl status jenkins

________________________________________
Step 3: Update Jenkins Configuration
1.	Open the Jenkins configuration file:
sudo vi /etc/default/jenkins
2.	Set the JAVA_HOME variable to the path of Java 17:
JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
3.	Save and exit the file.
________________________________________
Step 4: Restart Jenkins
Restart the Jenkins service to apply the changes:
sudo systemctl restart jenkins
Check the status to confirm Jenkins is running:
sudo systemctl status jenkins


3. Access Jenkins at http:// 52.66.195.151:8080
4. Unlock Jenkins using the password from:

   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   
5. Install recommended plugins.
6. Create first Admin user Sigmaadmin password Sigmaadmin (http://52.66.195.151:8080/ is the url in my case)
 

Step 2: Configure Jenkins for CI/CD

1. Install the following Jenkins plugins:
   - Docker Pipeline
   - GitHub Integration
   - AWS related Plugin
2. Set up Jenkins credentials:
   - GitHub Credentials: Add a personal access token or SSH key for repository access.
 
   - AWS Credentials: Add IAM user access/secret keys or configure EC2 role permissions.

 
 

 


4. Create a CI/CD Pipeline in Jenkins
Step 1: Define a Pipeline Job

1. Create a new Jenkins pipeline job.
2. Add your GitHub repository as the source under Pipeline.
Create a New Jenkins Pipeline Job
1.	Log in to Jenkins: Open your Jenkins web interface Go to New Item:
o	On the Jenkins dashboard, click New Item.
2.	Name Your Job:
o	Enter a meaningful name for your job (e.g., wordpress-docker-pipeline).
3.	Select Pipeline:
o	Choose Pipeline from the list of options.
o	Click OK.
4.	Configure General Settings:
o	Optionally, add a description for the job (e.g., "Pipeline for deploying WordPress on AWS EC2 using Docker").
________________________________________
Step 2: Add GitHub Repository as the Source
1.	Scroll to the Pipeline Section:
o	In the job configuration page, find the Pipeline section.
2.	Select Pipeline Definition:
o	Choose Pipeline script from SCM.
3.	Select SCM Type:
o	In the SCM dropdown, select Git.
4.	Add GitHub Repository URL:
o	Paste the URL of your GitHub repository (e.g., https://github.com/<your-username>/wordpress-docker-ec2.git).
5.	Add Credentials:
o	If your repository is private:
	Click Add (next to the Credentials dropdown).
	Select the credentials type (e.g., Username with password or SSH key) and provide details.
	Select your credentials from the dropdown.
o	If public, leave credentials blank.
6.	Specify the Branch:
o	By default, Jenkins uses the main branch. Change it if necessary (e.g., */main, */dev).
7.	Set the Script Path:
o	Enter the relative path to your pipeline script (e.g., Jenkinfilesigma) if it’s in your repository or create one navigate to write Jenkin file below
________________________________________
Step 3: Save the Job
1.	Scroll to the bottom of the page and click Save.
________________________________________

Verify that Docker is installed on your Jenkins agent (Ubuntu EC2 instance):
docker --version
If not, install Docker:
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker jenkins
Log out and back in to apply group changes.

Ensure AWS CLI is installed and configured. Run:
Step 1: Download the Installer
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
Step 2: Unzip the Installer
Install unzip if it's not already available:
sudo apt update
sudo apt install -y unzip
Then unzip the downloaded file:
unzip awscliv2.zip
Step 3: Run the Installer
sudo ./aws/install
Step 4: Verify the Installation
Check the installed version:
aws --version
You should see output like:
aws-cli/2.x.x Python/x.x.x Linux/x.x.x

root@ip-172-31-46-23:~/wordpresssigma# mkdir -p ~/wordpresssigma/wp-content
root@ip-172-31-46-23:~/wordpresssigma# touch ~/wordpresssigma/wp-content/index.php
root@ip-172-31-46-23:~/wordpresssigma# ls -l ~/wordpresssigma/wp-content
total 0
-rw-r--r-- 1 root root 0 Nov 16 09:02 index.php
root@ip-172-31-46-23:~/wordpresssigma#

Before rerun of automated pipeline ensure to execute below steps
docker build -t wordpress-app .

docker image prune -a -f


Access wordpress website using url http://52.66.240.176:9090/wp-admin/install.php

Username: Sigmaadmin
Password: qj8$EBwvM0%2XhZOsl


Step 4: Test the Pipeline
1.	Trigger a Build:
o	On the job's page, click Build Now.
2.	Monitor the Console Output:
o	Click the build number in the Build History section.
o	View the Console Output to check for errors or success.


Step 2: Write the Jenkinsfile

Create a Jenkinsfile in your GitHub repository root with the following content:

pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "wordpress-app"
        AWS_REGION = "ap-south-1"
        S3_BUCKET = "my-wordpress-deployments"
        MYSQL_CONTAINER = "mysql_container"
        WORDPRESS_CONTAINER = "wordpress_container"
        BASE_WORDPRESS_IMAGE = "wordpress:php8.1-apache"
        BASE_MYSQL_IMAGE = "mysql:5.7"
        KEEP_CONTAINERS_RUNNING = "true" // Set to 'true' to keep containers running
    }
    stages {
        stage('Cleanup Docker Environment') {
            steps {
                script {
                    sh """
                    echo "Checking and cleaning up Docker environment..."

                    if [ "${KEEP_CONTAINERS_RUNNING}" != "true" ]; then
                        # Stop and remove MySQL and WordPress containers if they exist
                        if [ \$(docker ps -aq -f name=${MYSQL_CONTAINER} | wc -l) -gt 0 ]; then
                            echo "Removing existing MySQL container..."
                            docker stop ${MYSQL_CONTAINER} || true
                            docker rm ${MYSQL_CONTAINER} || true
                        fi

                        if [ \$(docker ps -aq -f name=${WORDPRESS_CONTAINER} | wc -l) -gt 0 ]; then
                            echo "Removing existing WordPress container..."
                            docker stop ${WORDPRESS_CONTAINER} || true
                            docker rm ${WORDPRESS_CONTAINER} || true
                        fi

                        # Remove existing Docker images
                        if [ \$(docker images -q | wc -l) -gt 0 ]; then
                            echo "Removing existing Docker images..."
                            docker images -q | xargs -r docker rmi -f
                        fi

                        # Prune unused Docker volumes and networks
                        docker volume prune -f || true
                        docker network prune -f || true
                    else
                        echo "Skipping Docker environment cleanup as KEEP_CONTAINERS_RUNNING is set to true."
                    fi
                    """
                }
            }
        }
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/tiwarivive/wordpresssigma.git'
            }
        }
        stage('Pull Lightweight Base Images') {
            steps {
                script {
                    sh """
                    echo "Pulling base images..."
                    docker pull ${BASE_WORDPRESS_IMAGE}
                    docker pull ${BASE_MYSQL_IMAGE}
                    """
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    echo "Building Docker image..."
                    docker build -t ${DOCKER_IMAGE} --build-arg BASE_IMAGE=${BASE_WORDPRESS_IMAGE} .
                    """
                }
            }
        }
        stage('Run Containers') {
            steps {
                script {
                    sh """
                    echo "Starting MySQL container..."
                    docker run -d \
                        --name ${MYSQL_CONTAINER} \
                        -e MYSQL_ROOT_PASSWORD=root_password \
                        -e MYSQL_DATABASE=wordpress_db \
                        -e MYSQL_USER=wordpress_user \
                        -e MYSQL_PASSWORD=wordpress_password \
                        ${BASE_MYSQL_IMAGE}

                    echo "Starting WordPress container..."
                    docker run -d \
                        --name ${WORDPRESS_CONTAINER} \
                        --link ${MYSQL_CONTAINER}:mysql \
                        -e WORDPRESS_DB_HOST=${MYSQL_CONTAINER}:3306 \
                        -e WORDPRESS_DB_NAME=wordpress_db \
                        -e WORDPRESS_DB_USER=wordpress_user \
                        -e WORDPRESS_DB_PASSWORD=wordpress_password \
                        -p 9090:80 \
                        ${DOCKER_IMAGE}
                    """
                }
            }
        }
    }
    post {
        always {
            script {
                if (env.KEEP_CONTAINERS_RUNNING != "true") {
                    echo "Cleaning up Docker environment after pipeline execution..."
                    sh """
                    # Stop and remove running containers
                    if [ \$(docker ps -q | wc -l) -gt 0 ]; then
                        docker ps -q | xargs -r docker stop
                        docker ps -aq | xargs -r docker rm
                    fi

                    # Remove unused Docker images
                    if [ \$(docker images -q | wc -l) -gt 0 ]; then
                        docker images -q | xargs -r docker rmi -f
                    fi

                    # Prune unused Docker volumes and networks
                    docker volume prune -f || true
                    docker network prune -f || true
                    """
                } else {
                    echo "Skipping cleanup as KEEP_CONTAINERS_RUNNING is set to true."
                }
            }
        }
    }
} 


Steps to Clean WordPress:
bash
Copy code
# Stop and remove all WordPress containers
docker stop wordpress_container mysql_container || true
docker rm wordpress_container mysql_container || true

# Remove associated volumes
docker volume prune -f

# Remove unused images and networks
docker system prune -af



5. Automated Jenkin file Test Scenarios
pipeline {
    agent any
    stages {
        stage('Run Tests') {
            steps {
                script {
                    sh """
                    #!/bin/bash

                    echo "Running tests..."

                    echo "Waiting for WordPress to be ready..."
                    for i in {1..10}; do
                        curl -s http://localhost:9090 | grep -q "WordPress" && break
                        echo "Retrying in 5 seconds..."
                        sleep 5
                    done

                    # Check if WordPress is running
                    if curl -s http://localhost:9090 | grep -q "WordPress"; then
                        echo "WordPress is running"
                    else
                        echo "WordPress is not running"
                        exit 1
                    fi

                    # Database connection test
                    if docker exec mysql_container mysqladmin ping -hlocalhost -uroot -proot_password; then
                        echo "Database is reachable"
                    else
                        echo "Database is not reachable"
                        exit 1
                    fi

                    echo "All tests passed!"
                    """
                }
            }
        }
    }
}
Add this file to the GitHub repository and make it executable:
```bash
chmod +x run-tests.sh
git add run-tests.sh
git commit -m "Add test script"
git push origin main
```
6. Automate Infrastructure with CloudFormation

Step 1: Log in to the AWS Management Console
1.	Open AWS Management Console.
2.	Log in with your AWS account credentials.
________________________________________
Step 2: Navigate to CloudFormation
1.	In the AWS Management Console, search for "CloudFormation" in the top search bar and select CloudFormation.
2.	You will be directed to the CloudFormation Dashboard.
________________________________________
Step 3: Create a New Stack
1.	Click the Create stack button.
2.	Select "With new resources (standard)".
________________________________________
Step 4: Upload Your YAML File
1.	In the Specify template section:
o	Choose Upload a template file.
o	Click Choose file and select your YAML file (cloudformation-template.yaml) from your local machine.




Example of yaml file:

AWSTemplateFormatVersion: "2010-09-09"
Description: Deploy an Ubuntu EC2 instance and an S3 bucket in the default VPC, dynamically selecting a subnet.

Parameters:
  InstanceType:
    Description: EC2 instance type
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
    ConstraintDescription: Must be a valid EC2 instance type.

  KeyName:
    Description: Name of an existing EC2 KeyPair to enable SSH access to the instance
    Type: AWS::EC2::KeyPair::KeyName
    ConstraintDescription: Must be the name of an existing EC2 KeyPair.

  DefaultVpcId:
    Description: The ID of the default VPC
    Type: AWS::EC2::VPC::Id

Mappings:
  AvailabilityZones:
    ap-south-1:
      ZoneA: subnet-806c9aeb  # Replace with your subnet ID in ap-south-1a
      ZoneB: subnet-4bf6d107  # Replace with your subnet ID in ap-south-1b

Resources:
  SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow SSH and HTTP access
      VpcId: !Ref DefaultVpcId
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: !Ref InstanceType
      KeyName: !Ref KeyName
      SubnetId: !FindInMap [AvailabilityZones, ap-south-1, ZoneA]  # Dynamically selects subnet in ap-south-1a
      SecurityGroupIds:
        - !Ref SecurityGroup
      ImageId: ami-0dee22c13ea7a9a67  # Ubuntu 22.04 LTS AMI ID for ap-south-1
      Tags:
        - Key: Name
          Value: UbuntuInstance

  S3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub "example-bucket-${AWS::AccountId}-${AWS::Region}"
      AccessControl: Private
      Tags:
        - Key: Purpose
          Value: ExampleBucket

Outputs:
  InstanceId:
    Description: The ID of the EC2 instance
    Value: !Ref EC2Instance

  PublicIp:
    Description: The public IP address of the EC2 instance
    Value: !GetAtt EC2Instance.PublicIp

  S3BucketName:
    Description: The name of the S3 bucket
    Value: !Ref S3Bucket
2.	Click Next.
________________________________________
Step 5: Specify Stack Details
1.	Enter a Stack name (e.g., MyInfraStack).
2.	In the Parameters section, provide the following:
o	InstanceType: Choose from the allowed values (e.g., t2.micro).
o	KeyName: Enter the name of an existing EC2 KeyPair in your AWS account for SSH access.
________________________________________
Step 6: Configure Stack Options
1.	In the Configure stack options step:
o	Leave most settings as default unless you need specific tags or permissions.
o	Optionally, add tags to organize your resources (e.g., Key=Environment, Value=Development).
2.	Click Next.
________________________________________
Step 7: Review and Create the Stack
1.	Review the details of your stack configuration.
2.	Check the Acknowledgment box under the "Capabilities" section:
o	"I acknowledge that AWS CloudFormation might create IAM resources."
3.	Click Create stack.
________________________________________
Step 8: Monitor Stack Creation
1.	You will be redirected to the Stacks page, where you can monitor the progress.
2.	The status will go through stages such as:
o	CREATE_IN_PROGRESS
o	CREATE_COMPLETE
________________________________________
Step 9: Verify Created Resources
1.	Once the stack status is CREATE_COMPLETE:
o	EC2 Instance: Navigate to the EC2 service and verify that the instance is running.
o	S3 Bucket: Navigate to the S3 service and verify that the bucket is created.
________________________________________
Step 10: Access Outputs
1.	In the CloudFormation Stacks page, click on your stack name (e.g., MyInfraStack).
2.	Go to the Outputs tab to find:
o	The Instance ID and public IP of the EC2 instance.
o	The name of the created S3 bucket.
________________________________________
Step 11: Test the Infrastructure
1.	Use the public IP of the EC2 instance to SSH into the instance using your KeyPair:
bash
Copy code
ssh -i your-keypair.pem ec2-user@<public-ip>
2.	Verify that the S3 bucket is accessible from the AWS Console or through AWS CLI.



8. Testing and Validation

1. Trigger the Jenkins pipeline.
2. Verify:
   - WordPress is running on the deployed EC2 instance.
   - Test script passes.
      - CloudFormation stack of EC2 creation and S3 bucket creation is deployed correctly.

