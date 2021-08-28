# Base Docker Image
FROM frolvlad/alpine-miniconda3

#COPY/ADD <all> <the> <things> <last-arg-is-destination>
ADD  conda_anaconda.txt /conda_anaconda.txt
ADD  conda_forge.txt /conda_forge.txt

WORKDIR /

# Basic update
RUN ["apk", "update"]
RUN ["apk", "add", "git"]
RUN ["apk", "add", "bash", "nano"]

# Instaling Conda packs
RUN ["conda", "update", "--all"]
RUN ["conda", "install", "--yes", "-c", "conda-forge", "--file", "conda_forge.txt"]
RUN ["conda", "install", "--yes", "-c", "anaconda", "--file", "conda_anaconda.txt"]
RUN ["conda", "init"]

RUN mkdir /data
