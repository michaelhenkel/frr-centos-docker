FROM centos:7
COPY rpms/ /
RUN yum localinstall -y /x86_64/frr-5.10815-2018060501.el7.x86_64.rpm \
                        /x86_64/frr-pythontools-5.10815-2018060501.el7.x86_64.rpm 
CMD ["/usr/lib/frr/frr","start"]
