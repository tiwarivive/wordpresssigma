Standard Operating Procedure (SOP): Containerizing WordPress with Docker on AWS EC2
1. Introduction
This document outlines the steps required to containerize a WordPress application using Docker on an AWS EC2 instance, with persistent storage for the /wp-content directory, MySQL as the backend database, GitHub as the repository for code, and an S3 bucket for storing uploads. Additionally, an IAM role with necessary permissions will be configured for S3 access.
2. Prerequisites

1. **AWS Account**: Ensure you have an active AWS account.
2. **EC2 Instance**: Launch an EC2 instance.
3. **Security Group**: Configure the security group to allow:
   - Port 22 (SSH) for remote access.
   - Port 80 (HTTP) for web access.
4. **Install AWS CLI on EC2**:
   - [AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
5. **Docker and Docker Compose**:
   - Install Docker and Docker Compose on the EC2 instance.
    - sudo yum update -y
     - sudo yum install docker -y
     -   sudo systemctl start docker
     - sudo systemctl enable docker
     - sudo usermod -aG docker ec2-user (Add User to Docker Group)
 6. Install Docker Compose 
- sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
- docker-compose –version



6. **IAM Role**:
   - Attach an IAM role to the EC2 instance with permissions to access the S3 bucket.

To allow the EC2 instance to access an S3 bucket, attach an IAM role with appropriate permissions.

Step 1: Create an IAM Role

1. Log in to the AWS Management Console.
2. Navigate to the **IAM** service and click **Roles**.
3. Click **Create Role** and select **AWS Service** -> **EC2**.
4. Attach a policy with the following S3 permissions:
5. Complete the role creation process and give it a recognizable name (```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-s3-bucket-name",
        "arn:aws:s3:::your-s3-bucket-name/*"
      ]
    }
  ]
}
```


Step 2: Attach the IAM Role to the EC2 Instance

1. Navigate to the **EC2** dashboard in the AWS Management Console.
2. Select your EC2 instance and click **Actions** -> **Security** -> **Modify IAM Role**.
3. Select the newly created IAM role and click on Update IAM Role.

Step 3: Verify IAM Role Permissions

To test that the instance can access the S3 bucket, use the AWS CLI on the EC2 instance:

aws s3 ls s3:// wordpresss3bucket ( Replace with your bucket name)

3. Steps to Implement WordPress
Step 1: Create Project Structure

Create the following directory structure on your EC2 instance: ( You can follow your own structure also)

wordpress-docker/
├── docker-compose.yml
├── wordpress/
│   └── Dockerfile
└── .env

Step 2: Write docker-compose.yml File

Create a `docker-compose.yml` file with the following content:
```yaml file ‘’’
version: '3.9'

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress-app
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wp_user
      WORDPRESS_DB_PASSWORD: wp_password
      WORDPRESS_DB_NAME: wp_database
    volumes:
      - ./wordpress/wp-content:/var/www/html/wp-content
    depends_on:
      - db

  db:
    image: mysql:5.7
    container_name: wordpress-db
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: wp_database
      MYSQL_USER: wp_user
      MYSQL_PASSWORD: wp_password
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:


Step 3: Configure Persistent Storage for /wp-content
The `/wordpress/wp-content` directory is mapped to `/var/www/html/wp-content` in the container. 
All uploads and plugin data will persist in this directory.
Step 4: Build and Start Docker Containers

1. Create a `.env` file in the root directory with the following content:
```
WORDPRESS_DB_HOST=db:3306
WORDPRESS_DB_USER=wp_user
WORDPRESS_DB_PASSWORD=wp_password
WORDPRESS_DB_NAME=wp_database
MYSQL_ROOT_PASSWORD=root_password
```
2. Build and start the containers:
```bash
docker-compose up -d
```

Step 5: Configure WordPress Application

1. Access WordPress in your browser using the public IP of the EC2 instance.
   Example: `http://<your-ec2-public-ip>/wp-admin`
In my case http:// 52.66.91.44/wp-admin

2. Follow the WordPress setup instructions.
 

 

Username: Sigma_WordPress
Password : Q0R*^wLL@(%Wy@BdU^
Email: tiwarivive@gmail.com

 

Post Installation login with credentials created during installation.

 




Step 6: Push Project to GitHub
1. sudo yum install git -y (Run this in your EC2 Instance)
________________________________________
2. Create a GitHub Repository
1.	Log in to GitHub:
o	Open GitHub in your browser and log in.
2.	Create a New Repository:
o	Click the + icon in the top right corner and select New repository.
o	Provide the repository details:
	Repository Name: Enter a name for your 
	Description: Provide a brief description of the project.
	Public/Private: Choose public repository.
o	Click Create repository.
3.	SSH into your EC2 instance and navigate to your project directory
cd /root/wordpress-docker
4.	Initialize a Git repository
git init
5.	Add your files to the staging area
git add .
6.	Commit the files:
git commit -m "Wordpress15112024"

7.	Copy the repository URL from GitHub
o	On your repository page, click the green Code button and copy the HTTPS or SSH URL. (https://github.com/tiwarivive/wordpresssigma.git)
8.	Add the GitHub repository as a remote
git remote add origin https://github.com/tiwarivive/wordpresssigma.git

9.	Verify the remote
git remote -v

10.	Push your changes to the GitHub repository
 git branch -M main
git push -u origin main
remote: Support for password authentication was removed on August 13, 2021.
remote: Please see https://docs.github.com/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls for information on currently recommended modes of authentication.
fatal: Authentication failed for 'https://github.com/tiwarivive/wordpresssigma.git/'
[root@ip-172-31-44-24 wordpress-docker]#
The error occurs because GitHub no longer supports password-based authentication for HTTPS URLs. Instead, you need to use a Personal Access Token (PAT) or set up SSH keys for authentication

Option 1: Authenticate Using a Personal Access Token (Recommended)
1.	Generate a Personal Access Token:
o	Log in to your GitHub account.
o	Go to Settings -> Developer settings -> Personal access tokens -> Tokens (classic).
o	Click Generate new token and select:
	Expiration: Choose a suitable duration.
	Scopes: Enable at least repo and workflow permissions.
o	Generate the token and copy it (you won't be able to see it again).
2.	Use the Token Instead of a Password:




