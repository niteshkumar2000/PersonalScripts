# Install jdk-8 for jenkins
sudo apt-get install openjdk-8-jdk

# Add support for https apt sources by installing a couple of packages
sudo apt-get install apt-transport-https ca-certificates

# Install jenkins
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins

# Start jenkins
sudo systemctl start jenkins

# Check the status of jenkins
sudo systemctl status jenkins

# Jenkins uses a custom port 8080 to run, so you need to create a firewall to all access to this port.
# Once everything is done you can open your browser and enter your IP address followed by the Jenkins port 8080
# The format will be like this http://instance_external_ip:8080

# Rock nd Roll