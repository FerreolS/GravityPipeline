FROM fedora:latest
LABEL maintainer "Ferreol Soulez <ferreol.soulez@univ-lyon1.fr>"
ENV GRAVITYKIT=gravity-kit-1.6.6 
ENV GRAVITYVERSION=1.6.6
RUN dnf install dnf-plugins-core  libffi-devel java-latest-openjdk-devel wget subversion perl bzip2 gnuplot zlib-devel curl libcurl libcurl-devel -y  && \
    cd $HOME  && \
    wget -nv  https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/$GRAVITYKIT.tar.gz && \
    tar xzf $GRAVITYKIT.tar.gz && rm -f $GRAVITYKIT.tar.gz  && \
    cd $GRAVITYKIT  && \
    sed -i '911d' install_pipeline && sed -i 's/\&confirm(/0 and \&confirm(/g' install_pipeline && \
    sed -i '0,/   -t STDIN ||/s/    -t STDIN ||/  -t STDIN;/g' install_pipeline  && \
    echo "n"  |  ./install_pipeline   && \
    rm -rf gravity-calib-$GRAVITYVERSION && rm -rf cfitsio-3.49* esorex-3.13.5* fftw-3.3.9* cpl-7.1.4* erfa-1.7.1* gsl-2.6* wcslib-7.6* &&\
    cd gravity-$GRAVITYVERSION/ && make clean && \
    mkdir -p /work/data && ln -s /usr/local/calib/gravity-$GRAVITYVERSION /work/common_calibration && \
    cd $HOME  && wget  -nv ftp://ftp.eso.org/pub/eclipse/latest/eclipse-main-5.0.0.tar.gz && tar -xvzf eclipse-main-5.0.0.tar.gz && \
    rm eclipse-main-5.0.0.tar.gz && cd eclipse-5.0.0/ && ./configure && make && mv  bin/* /usr/local/bin/. && cd .. && rm -rf eclipse-5.0.0 && \
    cd $HOME  &&  wget  -nv https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -b  && rm -f Miniconda3-latest-Linux-x86_64.sh && \
    export PATH=$PATH:$HOME/miniconda3/bin  && \
    conda install -y reportlab astropy  && conda install -y -c conda-forge pdfrw && \
    svn co https://version-lesia.obspm.fr:/repos/DRS_gravity/gravi_tools3  && \
    echo "y" | pip3 install astropy matplotlib scipy joblib && \
    export PATH=$PATH:$HOME/gravi_tools3:$HOME/gravi_tools3/gravi_shell:$HOME/gravi_tools3/gravi_quicklook && \
    export PYTHONPATH=$HOME/gravi_tools3:$PYTHONPATH  && \
    dnf remove  subversion -y
WORKDIR /work/data
ENV PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/gravi_tools3:/root/gravi_tools3/gravi_shell:/root/gravi_tools3/gravi_quicklook:/root/miniconda2/bin
ENV PYTHONPATH=/root/gravi_tools3
ENTRYPOINT bash
