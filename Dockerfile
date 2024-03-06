FROM fedora:latest
LABEL maintainer "Ferreol Soulez <ferreol.soulez@univ-lyon1.fr>"
ENV GRAVITYKIT=gravity-kit-1.6.6 
ENV GRAVITYVERSION=1.6.6
RUN dnf install dnf-plugins-core  libffi-devel java-latest-openjdk-devel wget subversion perl bzip2 gnuplot zlib-devel curl libcurl libcurl-devel pip -y --setopt=install_weak_deps=False && \
    cd $HOME  && \
    wget -nv  https://ftp.eso.org/pub/dfs/pipelines/instruments/gravity/$GRAVITYKIT.tar.gz && \
    tar xzf $GRAVITYKIT.tar.gz && rm -f $GRAVITYKIT.tar.gz  && \
    cd $GRAVITYKIT  && \
    sed -i '911d' install_pipeline && sed -i 's/\&confirm(/0 and \&confirm(/g' install_pipeline && \
    sed -i '0,/   -t STDIN ||/s/    -t STDIN ||/  -t STDIN;/g' install_pipeline  && \
    echo "n"  |  ./install_pipeline   && \
    rm -rf gravity-calib-$GRAVITYVERSION && rm -rf cfitsio* esorex* fftw* cpl* erfa* gsl* wcslib* *.tar.gz &&\
    cd gravity-$GRAVITYVERSION/ && make clean && \
    mkdir -p /work/data && ln -s /usr/local/calib/gravity-$GRAVITYVERSION /work/common_calibration && \
    cd $HOME  && wget  -nv ftp://ftp.eso.org/pub/eclipse/latest/eclipse-main-5.0.0.tar.gz && tar -xvzf eclipse-main-5.0.0.tar.gz && \
    rm eclipse-main-5.0.0.tar.gz && cd eclipse-5.0.0/ && ./configure && make && mv  bin/* /usr/local/bin/. && cd .. && rm -rf eclipse-5.0.0 && \
    cd $HOME && svn co https://version-lesia.obspm.fr:/repos/DRS_gravity/gravi_tools3  && \
    echo "y" | pip3 install astropy matplotlib scipy joblib reportlab pdfrw svglib && \
    export PATH=$PATH:$HOME/gravi_tools3:$HOME/gravi_tools3/gravi_shell:$HOME/gravi_tools3/gravi_quicklook && \
    export PYTHONPATH=$HOME/gravi_tools3:$PYTHONPATH  && \
    dnf remove  subversion -y
WORKDIR /work/data
ENV PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/gravi_tools3:/root/gravi_tools3/gravi_shell:/root/gravi_tools3/gravi_quicklook:/root/miniconda2/bin
ENV PYTHONPATH=/root/gravi_tools3
ENTRYPOINT bash
