# Base Docker Image
FROM frolvlad/alpine-miniconda3

#COPY/ADD <all> <the> <things> <last-arg-is-destination>
ADD  scripts /scripts
ADD  conda_anaconda.txt /conda_anaconda.txt
ADD  conda_forge.txt /conda_forge.txt

WORKDIR /

# Basic update
#RUN ["apt-get", "update"]
#RUN ["apt-get", "dist-upgrade","-y"]
RUN ["apk", "update"]
RUN ["apk", "add", "bash"]

#SETUP SSH
RUN ["apk", "add", "-U", "openssh", "nano"]
RUN ["rm", "-rf", "/tmp/*", "/var/cache/apk/*"]
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
# END OF SSH SETUP

# Instaling Conda packs
RUN ["conda", "update", "--all"]
RUN ["conda", "install", "--yes", "-c", "conda-forge", "--file", "conda_forge.txt"]
RUN ["conda", "install", "--yes", "-c", "anaconda", "--file", "conda_anaconda.txt"]
RUN ["conda", "init"]

RUN mkdir /data

RUN ["chmod", "+x", "/scripts/install_list.sh"]

ENTRYPOINT ["sh", "/scripts/install_list.sh"]