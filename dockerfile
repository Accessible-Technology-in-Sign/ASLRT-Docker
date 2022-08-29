# A good explanation of the job flag for makefiles: https://www.gnu.org/software/make/manual/html_node/Parallel.html

# Base image is from Ubuntu 18.04 that has CUDA 11.1 installed
# This is because Azure Kinect SDK only has official releases for Ubuntu 18.04
# Changed CUDA to 10.2 because of nvcc error when building chainer-ctc, warp-transducer for ESPnet. Fix was to downgrade from CUDA 11 to CUDA 10.2: https://github.com/espnet/espnet/issues/2177
FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04

# Arguments for OpenCV
ARG DEBIAN_FRONTEND=noninteractive
ARG OPENCV_VERSION=4.5.0

# ----------------------------Linux Dependencies-------------------------
RUN apt-get update && apt-get upgrade -y &&\
    # Install Overall Dependencies
    apt-get install -y --no-install-recommends \
        g++ \
        make \
        cmake \
        automake \
        autoconf \
        bzip2 \
        unzip \
        wget \
        sox \
        libtool \
        subversion \
        zlib1g-dev \
        gfortran \
        ca-certificates \
        patch \
        ffmpeg \
        libsndfile1-dev \
        flac \
        vim \
        curl \
        nkf \
        nano \
        libfreetype6-dev \
        software-properties-common \
    # Install Dependencies for HTK
    && apt-get update && apt-get upgrade -y && apt-get install -y libc6-dev-i386 \
        ksh \
        bc \
        libx11-dev \
        # Since Guru has a Windows Computer, he needs to convert the Windows Line Endings to Unix Line Endings
        dos2unix \ 
    # Install Dependencies for OpenCV
    && apt-get update && apt-get upgrade -y && apt-get install -y \
    python3-pip \
        build-essential \
        yasm \
        pkg-config \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libpq-dev \
        libxine2-dev \
        libglew-dev \
        libtiff5-dev \
        zlib1g-dev \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libpostproc-dev \
        libswscale-dev \
        libeigen3-dev \
        libgtk2.0-dev \
        # Installs numpy for Python 2.7
        python-numpy \
    # ESPnet only works for Python 3.7 and above -- installing 3.8 because Python 3.7 failed for the "pip install -e ." command
        python3-dev \ 
        python3-pip \
    # Install dependencies for ESPnet
    && apt-get update && apt-get upgrade -y && apt-get -y install --no-install-recommends \ 
        apt-utils \
        gawk \
        libboost-all-dev \
        libbz2-dev \
        liblzma-dev \
        unzip \
        wget \
        zip \
        # Needed for installation of phonemizer (used by ESPnet)
        libncurses5-dev \
        libncursesw5-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# -----------------------------------------------------------------------

# -------------------------------Python Setup----------------------------
RUN add-apt-repository ppa:git-core/ppa -y && apt-get update && apt-get install git -y

# Install Miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    # Needed for chainer_ctc install
    /opt/conda/bin/python3 -m pip install --upgrade pip setuptools
ENV PATH=$CONDA_DIR/bin:$PATH
# -----------------------------------------------------------------------

# ---------------------------------HTK-----------------------------------
COPY ./htk ./htk
COPY ./gt2k ./gt2k
COPY ./prepare ./htk/prepare
# Deleted LetterLevel and WordLevel folders because they are not used in this project

WORKDIR /htk
RUN dos2unix prepare && chmod +x prepare
# This prepare script is where htk is built from scratch
RUN ./prepare

# -----------------------------------------------------------------------

# -------------------------------ESPnet----------------------------------
WORKDIR /
# Install Kaldi inside of ESPnet (source: http://jrmeyer.github.io/asr/2016/01/26/Installing-Kaldi.html)
RUN git clone https://github.com/espnet/espnet && \
    cd espnet/tools && \
    git clone https://github.com/kaldi-asr/kaldi.git && \
    # Ran the check_dependencies.sh script to check dependencies and saw that this needed to be run
    ./kaldi/tools/extras/install_mkl.sh && \
    cd kaldi/tools && \
    # Could not use -j due to packages not compiling. Removing -j fixed the issue: https://github.com/kaldi-asr/kaldi/issues/3987
    make -j "$(($(($((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) < $(nproc) ? $((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) : $(nproc)))>1 ? $(($((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) < $(nproc) ? $((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) : $(nproc))) : 1))" && \
    ./extras/install_irstlm.sh && \
    cd ../src && \
    # Run configure script with the fix from this source: https://github.com/kaldi-asr/kaldi/issues/4391
    ./configure --shared --use-cuda && \
    make -j clean depend && \
    make -j "$(($(($((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) < $(nproc) ? $((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) : $(nproc)))>1 ? $(($((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) < $(nproc) ? $((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) : $(nproc))) : 1))"

# Install ESPnet (source: https://espnet.github.io/espnet/installation.html)
# Additional resource: https://github.com/espnet/interspeech2019-tutorial/blob/master/notebooks/meetup/an4_meetup.ipynb
WORKDIR /espnet/tools
# Setting up system Python environment
RUN ./setup_anaconda.sh ${CONDA_DIR} base 3.8 && \
    make -j "$(($(($((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) < $(nproc) ? $((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) : $(nproc)))>1 ? $(($((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) < $(nproc) ? $((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) : $(nproc))) : 1))" && \
    ./setup_cuda_env.sh /usr/local/cuda && \
    # Based on running the python3 check_install.py, these packages need to be installed
    ./installers/install_chainer_ctc.sh && \
    ./installers/install_kenlm.sh && \
    ./installers/install_py3mmseg.sh && \
    ./installers/install_phonemizer.sh && \
    ./installers/install_gtn.sh && \
    ./installers/install_s3prl.sh && \
    ./installers/install_transformers.sh && \
    ./installers/install_speechbrain.sh && \
    ./installers/install_k2.sh && \
    ./installers/install_longformer.sh && \
    ./installers/install_pesq.sh && \
    ./installers/install_beamformit.sh && \
    ./installers/install_tdmelodic_pyopenjtalk.sh && \
    ./installers/install_fairseq.sh && \
    ./installers/install_sctk.sh && \
    ./installers/install_sph2pipe.sh && \
    # Optional packages for ESPnet
    ./installers/install_warp-ctc.sh && \
    ./installers/install_warp-transducer.sh && \
    ./installers/install_pyopenjtalk.sh && \
    python3 check_install.py
# -----------------------------------------------------------------------

# ----------------------------Azure Kinect SDK---------------------------
# In order to use apt-add-repository, we need to go back to Python3.6 as the default
WORKDIR /espnet/tools
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    apt-add-repository https://packages.microsoft.com/ubuntu/18.04/prod && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install k4a-tools -y && \
    apt-get install -y \
        libk4a1.4 \
        libk4a1.4-dev && \
    bash ./activate_python.sh && python3 -m pip install pyk4a 
# -----------------------------------------------------------------------

# --------------------------Python Dependencies--------------------------
# Will install all dependencies for the project simply by looking at the imports for the CopyCat-HTK repo. 
# ESPnet already installs a majority of them
# However, pip will just say "requirement installed" if it is already installed
RUN bash /espnet/tools/activate_python.sh && python3 -m pip install \
    numpy \
    torch \
    matplotlib \
    plotly \
    scipy \
    scikit-learn \
    pandas \
    tqdm \
    pytransform3d \
    joblib \
    mediapipe \
    filterpy \
    pympi-ling \
    ffprobe-python \
    tf-bodypix \
    tfjs-graph-converter \
    typing-extensions \
    kaldiio \
    humanfriendly \
    soundfile \
    typeguard \
    jupyter \
    numba \
    cupy-cuda102 \
    p-tqdm && \
    python3 -m pip uninstall -y opencv-contrib-python==4.6.0.66 && \
    python3 -m pip uninstall -y tensorflow

# Install Tensorflow from source since there isn't a TF Version for CUDA 10.2
RUN apt install apt-transport-https curl gnupg && \
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg && \
    mv bazel-archive-keyring.gpg /usr/share/keyrings && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    apt-get update && \
    apt-get install -y bazel-5.0.0 && \
    apt-get install -y openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/tensorflow/tensorflow.git && \
    cd tensorflow && \
    git checkout r2.9 && \
    python3 configure.py --use_gpu=True --cuda_compiled_path=/usr/local/cuda && \
    bazel build --config=opt --config=cuda --local_ram_resources="$(free -m | grep '^Mem:' | grep -o '[^ ]*$')" //tensorflow/tools/pip_package:build_pip_package && \
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && \
    python3 -m pip install /tmp/tensorflow_pkg/tensorflow-2.9.0-cp36-cp36m-linux_aarch64.whl && \
    rm -rf /tmp/tensorflow_pkg && \ 
    cd / && \
    rm -rf tensorflow
# -----------------------------------------------------------------------

# -------------------------------OpenCV----------------------------------
# Source: https://github.com/JulianAssmann/opencv-cuda-docker/blob/master/ubuntu-20.04/opencv-4.5/cuda-11.1/Dockerfile
WORKDIR /
RUN bash /espnet/tools/activate_python.sh && cd /opt/ &&\
    # Download and unzip OpenCV and opencv_contrib and delete zip files
    wget --quiet https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip &&\
    unzip -qq ${OPENCV_VERSION}.zip &&\
    rm ${OPENCV_VERSION}.zip &&\
    wget --quiet https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip &&\
    unzip -qq ${OPENCV_VERSION}.zip &&\
    rm ${OPENCV_VERSION}.zip &&\
    # Create build folder and switch to it
    mkdir /opt/opencv-${OPENCV_VERSION}/build && cd /opt/opencv-${OPENCV_VERSION}/build &&\
    # Cmake configure
    cmake \
        -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
        -DBUILD_opencv_python2=OFF \
        -DBUILD_opencv_python3=ON \
        -DWITH_CUDA=ON \
        -DCUDA_ARCH_BIN=6.1,7.0,7.5 \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DCUDNN_VERSION=8.0 \
        -DPYTHON3_LIBRARY=/opt/conda/lib/python3.8 \
        -DPYTHON3_INCLUDE_DIR=/opt/conda/include/python3.8 \
        -DPYTHON3_EXECUTABLE=/opt/conda/bin/python \
        -DPYTHON3_PACKAGES_PATH=/opt/conda/lib/python3.8/site-packages \
        .. &&\
    # Make
    make -j "$(($(($((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) < $(nproc) ? $((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) : $(nproc)))>1 ? $(($((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) < $(nproc) ? $((`free -g | grep '^Mem:' | grep -o '[^ ]*$'`/2)) : $(nproc))) : 1))" && \
    # Install to /usr/local/lib
    make install && \
    ldconfig && \
    # Remove OpenCV sources and build folder
    rm -rf /opt/opencv-${OPENCV_VERSION} && rm -rf /opt/opencv_contrib-${OPENCV_VERSION}
# -----------------------------------------------------------------------

# -------------------------------CopyCat---------------------------------
# Download the CopyCat-HTK repository
WORKDIR /
RUN git clone -b DataAugmentation https://github.com/ishanchadha01/CopyCat-HTK.git
# -----------------------------------------------------------------------
