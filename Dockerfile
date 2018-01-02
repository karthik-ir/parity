FROM kkarty/ubuntu-with-git-and-ssl:v1

WORKDIR /root

ARG rust_version=stable
ARG parity_build=master

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain $rust_version -y

ENV PATH=/root/.cargo/bin:$PATH
RUN mkdir /myvol
VOLUME /root/parity
#COPY ./parity /root/parity
WORKDIR /root/parity

ENTRYPOINT [ "cargo", "build", "--release"]

