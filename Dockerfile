FROM registry.access.redhat.com/ubi8/ubi-init
RUN yum install -y yum-utils;yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo;yum -y install terraform
RUN yum -y install unzip git python38 sudo 
RUN echo "Ec2160e745"|passwd --stdin root
RUN curl 'https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-macos.zip' -o 'awscli-exe.zip'
RUN unzip awscli-exe.zip
RUN ./aws/install
RUN python3 -m pip install gcloud
RUN mkdir /opt/pcs-toolbox
RUN git clone https://github.com/PaloAltoNetworks/pcs-toolbox.git /opt/pcs-toolbox/ 
COPY gcloud.repo /etc/yum.repos.d/
RUN yum -y  install google-cloud-sdk;yum clean all
RUN pip3 install requests certifi
COPY pc-settings.conf /opt/pcs-toolbox/ 
CMD [ "/sbin/init" ]
