FROM groovy

MAINTAINER Gregor Rot <gregor.rot@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zurich

USER root
RUN apt update
RUN apt-get install -y libbz2-dev
RUN apt-get install -y liblzma-dev
RUN apt-get install -y vim
RUN apt-get install -y python3
RUN apt-get install -y git
RUN apt-get install -y python3-pip
RUN apt-get install -y rna-star
RUN apt-get install -y samtools

# matplotlib
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y libpng-dev
RUN apt-get install -y pkg-config

RUN pip3 install pysam
RUN pip3 install numpy
RUN pip3 install matplotlib==3.2
RUN pip3 install regex
RUN pip3 install pandas

# R (from rep)
#RUN apt-get install -y software-properties-common
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
#RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
#RUN apt-get install -y r-base r-base-core r-recommended r-base-dev
#RUN R -e 'install.packages("BiocManager", repos = "http://cran.us.r-project.org")'
#RUN R -e 'BiocManager::install("edgeR")'

# R (compile dep)
RUN apt-get install -y build-essential
RUN apt-get install -y fort77
RUN apt-get install -y liblzma-dev libblas-dev gfortran
RUN apt-get install -y gobjc++
RUN apt-get install -y libpcre2-dev
RUN apt-get install -y aptitude
RUN aptitude install -y libreadline-dev
RUN apt-get install -y default-jre
RUN apt-get install -y default-jdk
RUN apt-get install -y openjdk-8-jdk openjdk-8-jre
RUN apt-get install -y libcurl4-openssl-dev

# student user
RUN useradd -m -d /home/student student
#ADD . /home/student/teachingDocker
RUN chown -R student.student /home/student

USER student
WORKDIR /home/student
RUN mkdir ~/data
RUN echo "alias python='python3'" >> ~/.bashrc

# salmon
RUN mkdir ~/software
RUN wget https://github.com/COMBINE-lab/salmon/releases/download/v1.4.0/salmon-1.4.0_linux_x86_64.tar.gz -O ~/software/salmon.tgz
WORKDIR /home/student/software
RUN tar xfz salmon.tgz
RUN rm salmon.tgz
RUN mv salmon-latest_linux_x86_64/ salmon

# R (compile)
WORKDIR /home/student/software
RUN wget https://cran.r-project.org/src/base/R-4/R-4.0.5.tar.gz
RUN tar xfz R-4.0.5.tar.gz
RUN mv R-4.0.5 R
RUN rm R-4.0.5.tar.gz
WORKDIR /home/student/software/R
RUN ./configure --with-x=no
RUN make
WORKDIR /home/student/software/R/bin
RUN ./R -e 'install.packages("BiocManager", repos = "http://cran.us.r-project.org")'
RUN ./R -e 'BiocManager::install("edgeR")'

# paths
RUN echo "export PATH=$PATH:~/software/salmon/bin" >> ~/.bashrc
RUN echo "export PATH=$PATH:~/software/R/bin" >> ~/.bashrc
RUN echo "export PYTHONPATH=$PYTHONPATH:/home/student" >> ~/.bashrc

WORKDIR /home/student