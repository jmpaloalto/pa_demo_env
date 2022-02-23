FROM registry.access.redhat.com/ubi8/ubi-init
COPY gcloud.repo /etc/yum.repos.d/
RUN yum install -y yum-utils;yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo;yum -y install terraform unzip git python38 sudo google-cloud-sdk; yum clean all
RUN curl 'https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip' -o 'awscli-exe.zip' 
RUN unzip awscli-exe.zip
RUN aws/install
RUN python3 -m pip install gcloud
RUN mkdir /opt/pcs-toolbox
RUN git clone https://github.com/PaloAltoNetworks/pcs-toolbox.git /opt/pcs-toolbox/ 
COPY pc-settings.conf /opt/pcs-toolbox/ 
RUN groupadd -g 10000 palos;useradd -s /bin/bash -g palos -G palos -u 1000810000 pcs-user
RUN chown -Rf pcs-user.palos /opt/pcs-toolbox/
COPY azinstall.py /tmp/
RUN python3 /tmp/azinstall.py
RUN pip3 install requests certifi
USER pcs-user
WORKDIR /home/pcs-user
CMD [ "/sbin/init" ]
