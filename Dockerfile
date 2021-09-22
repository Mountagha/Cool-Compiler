FROM ubuntu

RUN apt update
RUN apt install -y \
    flex \
    bison \
    csh  \
    build-essential
RUN mkdir /usr/class
RUN chown $USER /usr/class
COPY cs143 /usr/class/
WORKDIR ~/cool
RUN ln -s /usr/class/cs143/cool 
RUN PATH=/usr/class/cs143/cool/bin:$PATH
CMD /bin/bash
