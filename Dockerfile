FROM ubuntu:latest

MAINTAINER Manfred Touron (@moul)
MAINTAINER Jevin Sweval (@jevinskie)


# Install dependencies
RUN apt-get update               \
 && apt-get -y -q upgrade        \
 && apt-get -y -q install        \
    bc                           \
    build-essential              \
    ccache                       \
    nano                         \
    file                         \
    gcc                          \
    git                          \
    libncurses-dev               \
    libssl-dev                   \
    wget                         \
    xz-utils                     \
 && apt-get clean

# Fetch the kernel
ENV CCACHE_DIR=/ccache       \
    SRC_DIR=/usr/src         \
    LINUX_DIR=/usr/src/linux \
    LINUX_REPO_URL=https://github.com/linuxkit/linux
RUN mkdir -p ${SRC_DIR} ${CCACHE_DIR}   \
 && cd /usr/src     \
 && git clone --depth 1 -b v4.10.13-linuxkit ${LINUX_REPO_URL} ${LINUX_DIR} \
 && cd ${LINUX_DIR} \
 && git clone --depth 1 -b aufs4.10 https://github.com/sfjro/aufs4-standalone \
 && git clone --depth 1 -b aufs4.1 https://github.com/ncopa/aufs-util \
 && patch -p1 < aufs4-standalone/aufs4-kbuild.patch \
 && patch -p1 < aufs4-standalone/aufs4-base.patch \
 && patch -p1 < aufs4-standalone/aufs4-mmap.patch \
 && cp -R aufs4-standalone/Documentation/* Documentation/ \
 && cp -R aufs4-standalone/fs/* fs/ \
 && cp aufs4-standalone/include/uapi/linux/aufs_type.h include/uapi/linux \
 && sed -i'' -e 's/default m/default y/g' fs/nfs/Kconfig
WORKDIR ${LINUX_DIR}
