FROM registry.access.redhat.com/ubi8/ubi-init
COPY gcloud.repo /etc/yum.repos.d/
COPY .okta-aws /home/pcs-user/
RUN yum install -y yum-utils;yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo;yum -y install terraform unzip git python38 sudo google-cloud-sdk; yum clean all
RUN curl 'https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip' -o 'awscli-exe.zip' 
RUN unzip awscli-exe.zip
RUN aws/install
RUN python3 -m pip install gcloud
RUN mkdir -p /opt/pcs-toolbox /opt/aws/eks
COPY eks.json /opt/aws/eks
RUN git clone https://github.com/PaloAltoNetworks/pcs-toolbox.git /opt/pcs-toolbox/ 
COPY pc-settings.conf /opt/pcs-toolbox/ 
RUN groupadd -g 10000 palos;useradd -s /bin/bash -g palos -G palos -u 1000810000 pcs-user
RUN chown -Rf pcs-user.palos /opt/pcs-toolbox/ /home/pcs-user/.okta-aws
COPY azinstall.py /tmp/
RUN python3 /tmp/azinstall.py
RUN pip3 install requests certifi okta-awscli
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
USER pcs-user
WORKDIR /home/pcs-user
CMD [ "/sbin/init" ]
