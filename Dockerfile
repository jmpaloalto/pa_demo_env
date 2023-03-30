FROM registry.access.redhat.com/ubi8/ubi
COPY gcloud.repo /etc/yum.repos.d/
COPY .okta-aws /home/pcs-user/
RUN yum install -y zsh java-11-openjdk-devel rsync yum-utils;yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo;yum -y install terraform unzip git python38 sudo google-cloud-sdk; yum clean all
RUN groupadd -g 10000 palos;useradd -s /bin/bash -g palos -G palos -u 1000810000 pcs-user
RUN chown -Rf pcs-user.palos /home/pcs-user
RUN runuser -l pcs-user -c 'curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh| sh'
COPY .zshrc .profile /home/pcs-user/
RUN curl 'https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip' -o 'awscli-exe.zip';curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN unzip awscli-exe.zip
RUN aws/install
RUN python3 -m pip install gcloud pyyaml requests packaging pyopenssl certifi prismacloud-cli
RUN mkdir -p /opt/pcs-toolbox /opt/aws/eks /opt/terraform /opt/jenkins /home/pcs-user/.ssh
COPY jenkins-cli.jar /opt/jenkins/
COPY eks.json /opt/aws/eks/
COPY okta-aws-cli /usr/local/bin/
RUN git clone https://github.com/PaloAltoNetworks/pcs-toolbox.git /opt/pcs-toolbox/ 
COPY pc-settings.conf /opt/pcs-toolbox/ 
COPY azinstall.py /tmp/
COPY run.py /usr/local/bin/
RUN python3 /tmp/azinstall.py
RUN chmod +x ./kubectl ./oc
RUN mv ./kubectl /usr/local/bin
COPY twistcli /usr/local/bin/
COPY mv ./oc /usr/local/bin/


RUN chmod +x /usr/local/bin/twistcli /usr/local/bin/run.py /usr/local/bin/okta-aws-cli
RUN chown -Rf pcs-user.palos /opt/pcs-toolbox/ /home/pcs-user/.okta-aws /home/pcs-user /home/pcs-user/.ssh /home/pcs-user/.zshrc /home/pcs-user/.bashrc /home/pcs-user/.profile /opt/terraform
USER pcs-user
WORKDIR /home/pcs-user
ENV ENV=~/.profile 
CMD [ "/sbin/init" ]
