FROM archlinux:latest

RUN pacman -Syu --noconfirm cmake base-devel bison flex libedit git

RUN git clone https://github.com/nbdy/shrewvpn

RUN cd shrewvpn && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install

ENTRYPOINT ["bash"]
