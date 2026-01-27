FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apt-utils git curl build-essential software-properties-common sudo \
    g++ python3 cmake ninja-build ccache gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo \
    python3-pygraphviz gir1.2-gtk-3.0 python3-dev pkg-config sqlite3 cmake python3-setuptools \
    qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools mercurial unzip gdb valgrind clang \
    clang-format doxygen graphviz imagemagick python3-sphinx gsl-bin libgsl-dev libgslcblas0 \
    tcpdump libsqlite3-dev libxml2 libxml2-dev libc6-dev libc6-dev-i386 libclang-dev llvm-dev \
    automake python3-pip libgtk-3-dev libxml2 libxml2-dev libboost-all-dev libgrpc++-dev \
    libprotobuf-dev protobuf-compiler libdpdk-dev libssh-dev \
    autoconf libtool pkg-config cmake libgsl23

RUN add-apt-repository ppa:sumo/stable && apt-get update && \
    apt-get install -y sumo sumo-tools sumo-doc

RUN useradd -ms /bin/bash van3t && \
    echo "van3t ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER van3t

RUN cd /home/van3t && \
    git clone https://github.com/DriveX-devs/VaN3Twin.git && \
    cd VaN3Twin && \
    ./sandbox_builder.sh install-dependencies && \
    cd ns-3-dev && \
    ./ns3 configure --build-profile=optimized --enable-examples --enable-tests --disable-python && \
    ./ns3 build && \
    ./ns3 configure --enable-sudo && \
    ./ns3 build v2x-emulator

WORKDIR /home/van3t/VaN3Twin

CMD ["/bin/bash"]