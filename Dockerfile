FROM ubuntu

RUN apt-get update
RUN apt-get install -y \
    flex \
    bison \
    csh  \
    vim \
    build-essential
RUN mkdir -p /usr/class/cs143/cool
RUN chown $USER:$USER /usr/class/cs143/cool
WORKDIR /usr/class/cs143/cool
COPY cs143/cool/ ./ 
RUN ls -l
RUN pwd 
# WORKDIR /usr/class/cs143/cool
# RUN pwd
RUN id
COPY setup.sh ./ 
RUN chmod +x setup.sh
# RUN ls -l
# RUN pwd
RUN ./setup.sh
ENV PATH="/usr/class/cs143/cool/bin:${PATH}"
# ENTRYPOINT [ "/bin/bash" ] 
