FROM fedora:32
LABEL maintainer "Ferreol Soulez <ferreol.soulez@univ-lyon1.fr>"
RUN dnf install dnf-plugins-core  libffi-devel java-latest-openjdk-devel wget subversion perl bzip2 -y  && \
    cd $HOME  && \
    wget https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/gravity-kit-1.5.0-6.tar.gz && \
    tar xzf gravity-kit-1.5.0-6.tar.gz && rm -f gravity-kit-1.5.0-6.tar.gz  && \
    cd gravity-kit-1.5.0-6  && \
    sed -i '911d' install_pipeline && sed -i 's/confirm(/0 and confirm(/g' install_pipeline && \ 
    sed -i '0,/   -t STDIN ||/s/    -t STDIN ||/  -t STDIN;/g' install_pipeline  && \
    echo "n"  |  ./install_pipeline   && \
    mkdir -p /work/data && mv /usr/local/calib/gravity-1.5.0-6 /work/common_calibration && \
    cd $HOME  &&  wget https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh  && \
    bash ./Miniconda2-latest-Linux-x86_64.sh -b  && rm -f Miniconda2-latest-Linux-x86_64.sh && \ 
    export PATH=$PATH:$HOME/miniconda2/bin  && \
    conda install -y reportlab astropy && conda install -y -c conda-forge pdfrw && \
    svn co https://version-lesia.obspm.fr:/repos/DRS_gravity/python_tools  && \
    echo "y" | pip install pyfits && \
    export PATH=$PATH:$HOME/python_tools:$HOME/python_tools/gravi_shell:$HOME/python_tools/gravi_quicklook && \
    export PYTHONPATH=$HOME/python_tools:$PYTHONPATH  && \
    dnf remove java-latest-openjdk-devel wget subversion -y
WORKDIR /work/data
ENV PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/python_tools:/root/python_tools/gravi_shell:/root/python_tools/gravi_quicklook:/root/miniconda2/bin
ENV PYTHONPATH=/root/python_tools
ENTRYPOINT bash


