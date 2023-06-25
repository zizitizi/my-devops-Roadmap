FROM ubuntu:20.04
Set environment variablesENV DEBIAN_FRONTEND noninteractive
Update the package list and install dependenciesRUN apt-get update \
&& apt-get install -y --no-install-recommends
        ca-certificates
        curl
        openssh-server
        tzdata
        perl
    && apt-get clean
    && rm -rf /var/lib/apt/lists/*

Install GitLab CERUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash \
&& apt-get install -y --no-install-recommends gitlab-ce

Configure GitLab
RUN echo "external_url 'http://localhost'" >> /etc/gitlab/gitlab.rb

Expose the necessary portsEXPOSE 22 80 443
Start GitLab serviceCMD (gitlab-ctl reconfigure && gitlab-ctl tail) & wait```
Step 4: Save and close the Dockerfile.

Step 5: Build the Docker image using the following command:


docker build -t gitlab-ce .
Step 6: Run the GitLab CE container using the following command:


docker run -d -p 80:80 -p 443:443 -p 22:22 --name gitlab gitlab-ce```

This Dockerfile installs GitLab CE on an Ubuntu 20.04 base image,