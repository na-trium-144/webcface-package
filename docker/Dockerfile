ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}
COPY *.deb /tmp/
RUN apt-get install -y /tmp/*.deb
CMD ["webcface-server"]
