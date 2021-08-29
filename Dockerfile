FROM python:3-onbuild
WORKDIR /data

RUN wget https://sourceforge.net/projects/ciri/files/CIRIquant/test_data.tar.gz  && tar -xvf test_data.tar.gz && rm test_data.tar.gz
