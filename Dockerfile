
FROM gcr.io/google_samples/gb-frontend:v5

USER root

#Secret exposed
COPY id_rsa ~/.ssh/id_rsa
COPY evil /evil

#Virus included
COPY evil /evil
RUN curl https://wildfire.paloaltonetworks.com/publicapi/test/elf -o evil-WF

#Install vulnerable os level packages
#Hashing out as it didn't install it originally....:  CMD apt-get install nmap nc
RUN apt-get update \
        && apt-get install -y nmap \
        && apt-get install -y netcat

#Expose vulnerable ports
EXPOSE 22
EXPOSE 80

#Gen traffic

# RUN  curl frontend.guestbook.svc.cluster.local/guestbook.php?cmd=get 

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh


 
ENTRYPOINT ["entrypoint.sh"]
