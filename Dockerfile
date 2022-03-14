FROM registry.access.redhat.com/ubi8/ubi-init
COPY gcloud.repo /etc/yum.repos.d/
COPY .okta-aws /home/pcs-user/
COPY .profile /home/pcs-user/
RUN yum install -y yum-utils;yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo;yum -y install terraform unzip git python38 sudo google-cloud-sdk; yum clean all
RUN curl 'https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip' -o 'awscli-exe.zip';curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN unzip awscli-exe.zip
RUN aws/install
RUN python3 -m pip install gcloud pyyaml requests packaging pyopenssl certifi okta-awscli
RUN mkdir -p /opt/pcs-toolbox /opt/aws/eks /opt/terraform
COPY eks.json /opt/aws/eks
RUN git clone https://github.com/PaloAltoNetworks/pcs-toolbox.git /opt/pcs-toolbox/ 
COPY pc-settings.conf /opt/pcs-toolbox/ 
RUN groupadd -g 10000 palos;useradd -s /bin/bash -g palos -G palos -u 1000810000 pcs-user
COPY azinstall.py /tmp/
COPY run.py /usr/local/bin/
RUN python3 /tmp/azinstall.py
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
COPY twistcli /usr/local/bin/
RUN chmod +x /usr/local/bin/twistcli /usr/local/bin/run.py
RUN chown -Rf pcs-user.palos /opt/pcs-toolbox/ /home/pcs-user/.okta-aws /home/pcs-user /home/pcs-user/.bashrc /home/pcs-user/.profile /opt/terraform
USER pcs-user
WORKDIR /home/pcs-user
ENV ENV=~/.profile 
CMD [ "/sbin/init" ]
