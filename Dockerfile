FROM groovy

MAINTAINER Gregor Rot <gregor.rot@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zurich

USER root
RUN yes | unminimize
RUN apt-get update
RUN apt-get install -y man libbz2-dev liblzma-dev vim python3 git python3-pip rna-star samtools nano libxml2-dev libfreetype6-dev pkg-config libpng-dev pkg-config build-essential fort77 liblzma-dev libblas-dev gfortran gobjc++ libpcre2-dev aptitude libreadline-dev default-jre default-jdk openjdk-8-jdk openjdk-8-jre libcurl4-openssl-dev
RUN pip3 install pysam numpy matplotlib==3.2 regex pandas HTSeq

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

# SOAPec, picard
WORKDIR /home/student/software
RUN wget http://sourceforge.net/projects/soapdenovo2/files/ErrorCorrection/SOAPec_v2.01.tar.gz
RUN tar xfz SOAPec_v2.01.tar.gz
RUN rm SOAPec_v2.01.tar.gz
RUN wget https://github.com/broadinstitute/picard/releases/download/2.23.8/picard.jar

# R (compile)
WORKDIR /home/student/software
RUN wget https://cran.r-project.org/src/base/R-4/R-4.0.5.tar.gz
RUN tar xfz R-4.0.5.tar.gz
RUN mv R-4.0.5 R
RUN rm R-4.0.5.tar.gz
WORKDIR /home/student/software/R
RUN ./configure --with-x=no
RUN make

WORKDIR /home/student

# Bio610 data
RUN mkdir materials
RUN wget https://drive.switch.ch/index.php/s/T0aepfrKjOBuk9P/download -O ~/materials/ngslec.tgz

# Bio634 data
RUN wget https://bioinfo.evolution.uzh.ch/share/data/bio634/DATA_NGS2_SNP.zip -O ~/materials/DATA_NGS2_SNP.zip
RUN wget https://bioinfo.evolution.uzh.ch/share/data/bio634/EcoliDH10B.fa -O ~/materials/EcoliDH10B.fa
RUN wget https://bioinfo.evolution.uzh.ch/share/data/bio634/EcoliDH10B.gff -O ~/materials/EcoliDH10B.gff
RUN wget https://bioinfo.evolution.uzh.ch/share/data/bio634/MiSeq_Ecoli_DH10B_110721_PF_subsample.bam -O ~/materials/MiSeq_Ecoli_DH10B_110721_PF_subsample.bam

# freebayes
WORKDIR /home/student/software
RUN mkdir freebayes
WORKDIR /home/student/software/freebayes
RUN wget https://github.com/freebayes/freebayes/releases/download/v1.3.4/freebayes-1.3.4-linux-static-AMD64.gz -O freebayes.gz
RUN gunzip freebayes.gz
RUN chmod +x freebayes

# trimgalore
WORKDIR /home/student/software
RUN wget https://github.com/FelixKrueger/TrimGalore/archive/refs/tags/0.6.6.zip -O trim.zip
RUN unzip trim.zip
RUN rm trim.zip

# some additional software
USER root
RUN apt-get install -y bwa tabix libssl-dev
RUN python3 -m pip install --upgrade cutadapt

USER student

# vt
WORKDIR /home/student/software
RUN git clone https://github.com/atks/vt.git
WORKDIR /home/student/software/vt
RUN git submodule update --init --recursive
RUN make

# bio634 specific software
WORKDIR /home/student/software
RUN wget https://bioinfo.evolution.uzh.ch/share/data/bio634/bio634_software_specific.tgz
RUN tar xfz bio634_software_specific.tgz
RUN rm bio634_software_specific.tgz
RUN mv storage/* .
RUN rm -r storage

# paths
RUN echo 'export PATH=$PATH:~/software/salmon/bin:~/software/R/bin:~/software/miniconda/bin:~/software/freebayes:~/software/SOAPec_v2.01/bin:~/software/TrimGalore-0.6.6:~/software/vt' >> ~/.bashrc

# some more R packages
WORKDIR /home/student/software/R/bin
RUN ./R -e 'install.packages("BiocManager", repos = "http://cran.us.r-project.org")'
RUN ./R -e 'BiocManager::install(update=TRUE, ask=FALSE, c("edgeR", "csaw", "tximport", "tximportData", "rhdf5", "VennDiagram", "Matrix", "airway", "Rsamtools", "pasilla", "GenomicFeatures", "GenomicAlignments", "BiocParallel", "Rsubread", "DESeq2"))'

# conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/software/miniconda
RUN rm Miniconda3-latest-Linux-x86_64.sh
RUN /home/student/software/miniconda/bin/conda init
RUN . "/home/student/software/miniconda/etc/profile.d/conda.sh"
RUN /home/student/software/miniconda/bin/conda install -c bioconda fastqc trimmomatic bowtie2 -y
RUN ln -s /home/student/software/miniconda/lib/libcrypto.so.1.1 /home/student/software/miniconda/lib/libcrypto.so.1.0.0
RUN /home/student/software/miniconda/bin/conda install -c bioconda soapdenovo2 bcftools bedtools -y

WORKDIR /home/student
