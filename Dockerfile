FROM groovy

MAINTAINER Gregor Rot <gregor.rot@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zurich

USER root
RUN apt update
RUN apt-get install -y vim
RUN apt-get install -y python3
RUN apt-get install -y git
RUN apt-get install -y python3-pip
RUN apt-get install -y rna-star
RUN apt-get install -y samtools
RUN pip3 install pysam
RUN pip3 install numpy
RUN pip3 install matplotlib==3.2
RUN pip3 install regex
RUN pip3 install pandas

# R
RUN apt-get install -y software-properties-common
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN apt install -y r-base r-base-core r-recommended r-base-dev
RUN R -e 'install.packages("BiocManager")'
RUN R -e 'BiocManager::install("edgeR")'

# student user
RUN useradd -m -d /home/student student
#ADD . /home/student/teachingDocker
RUN chown -R student.student /home/student

USER student
WORKDIR /home/student
RUN mkdir ~/data
RUN echo "alias python='python3'" >> ~/.bashrc

# paths
#RUN echo "export PATH=$PATH:/home/apauser/apa/bin:/home/apauser/pybio/bin:~/software/salmon/bin" >> ~/.bashrc
#RUN echo "export PYTHONPATH=$PYTHONPATH:/home/apauser" >> ~/.bashrc

WORKDIR /home/student
