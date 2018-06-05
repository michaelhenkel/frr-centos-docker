FROM centos:7 as source-builder
ARG commit
RUN yum install -y git autoconf automake libtool make gawk \
    readline-devel texinfo net-snmp-devel groff pkgconfig \
    json-c-devel pam-devel bison flex pytest c-ares-devel \
    perl-XML-LibXML python-devel systemd-devel python-sphinx \
    rpm-build net-snmp-devel pam-devel systemd-devel libcap-devel
RUN git clone https://github.com/FRRouting/frr /frr && \
    (cd /frr && \
    ./bootstrap.sh && \
    export enable_cumulus=yes && \
    ./configure \
        --enable-numeric-version \
        --enable-cumulus \
        --with-pkg-extra-version=-0.1 \
        --with-pkg-extra-version=0815 && \
    make SPHINXBUILD=sphinx-build2.7 dist)
#COPY frr.spec /frr/redhat/
RUN  (cd /frr && \ 
     mkdir rpmbuild && \
     mkdir rpmbuild/SOURCES && \
     mkdir rpmbuild/SPECS && \
     cp redhat/*.spec rpmbuild/SPECS/ && \
     cp frr*.tar.gz rpmbuild/SOURCES/ && \
     sed -i '/\ \ \ \ --enable-poll=yes/i \ \ \ \ --enable-cumulus=yes \\' rpmbuild/SPECS/frr.spec && \
     rpmbuild --define "_topdir `pwd`/rpmbuild" -ba rpmbuild/SPECS/frr.spec )
RUN grep cumulus /frr/rpmbuild/SPECS/frr.spec
FROM centos:7
RUN mkdir -p /rpms
COPY --from=source-builder /frr/rpmbuild/RPMS/ /rpms
