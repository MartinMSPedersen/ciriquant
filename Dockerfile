FROM python:2.7-onbuild
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN apt-get update && apt-get upgrade && apt-get install -y unzip

ADD https://sourceforge.net/projects/ciri/files/CIRIquant/CIRIquant_v0.2.0.tar.gz . 
ADD https://sourceforge.net/projects/ciri/files/CIRIquant/test_data.tar.gz .
ADD https://github.com/samtools/samtools/archive/1.9.zip .
RUN unzip 1.9.zip && rm 1.9.zip
ADD https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2 .
RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-source.zip 
RUN unzip hisat2-2.1.0-source.zip && rm hisat2-2.1.0-source.zip 
ADD http://ccb.jhu.edu/software/stringtie/dl/stringtie-2.0.3.tar.gz .
ADD https://github.com/samtools/htslib/archive/1.9.zip .
RUN unzip 1.9.zip && rm 1.9.zip

# bwa
WORKDIR /usr/src/app/bwa-0.7.17
RUN make && ln -s $PWD/bwa /bin

# hisat
WORKDIR /usr/src/app/hisat2-2.1.0
RUN make && ln -s $PWD/hisat2-build-{s,l} $PWD/hisat2-inspect-{s,l} $PWD/hisat2-align-{s,l} $PWD/hisat2 /bin

# stringtie
WORKDIR /usr/src/app/stringtie-2.0.3
RUN make clean release && ln -s $PWD/stringtie /bin

# htslib
WORKDIR /usr/src/app/htslib-1.9
RUN autoreconf && ./configure && make && make install

# samtools
WORKDIR /usr/src/app/samtools-1.9
RUN autoreconf && ./configure && make && make install
RUN ln -s $PWD/samtools /bin

# CIRIQuant
WORKDIR /usr/src/app/CIRIquant
RUN python setup.py install

# travis 
RUN mkdir -p /home/travis/miniconda/envs/CIRIquant/ && ln -s /bin /home/travis/miniconda/envs/CIRIquant/
