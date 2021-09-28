#!/bin/bash

echo "Installing R-base and R Studio"
apt -y update
apt -y upgrade

apt -y install r-base gdebi-core

wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.4.1717-amd64.deb
gdebi rstudio-1.4.1717-amd64.deb
