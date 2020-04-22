# Copyright (c) 2019-2020, RTE (https://www.rte-france.com)
# See AUTHORS.txt
# This Source Code Form is subject to the terms of the Mozilla Public License, version 2.0.
# If a copy of the Mozilla Public License, version 2.0 was not distributed with this file,
# you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
# This file is part of Grid2Op, Grid2Op a testbed platform to model sequential decision making in power systems.

# Use an official Python runtime as a parent image
FROM python:3.6-stretch

MAINTAINER Benjamin DONNOT <benjamin.donnot@rte-france.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
    less \
    apt-transport-https \
    git \
    ssh \
    tar \
    gzip \
    ca-certificates

# Retrieve Grid2Op
RUN git clone https://github.com/bdonnot/Grid2Op

# Install Grid2Op
WORKDIR /Grid2Op
# Use the latest release
RUN git pull
RUN git remote update
RUN git fetch --all --tags --force
RUN git pull origin 071_dev
# Install Dependencies
RUN pip3 install -U .[test]
# force the "install" of test data in proper repo
WORKDIR /
RUN python3 -c "import grid2op; import os; print(os.path.split(grid2op.__file__)[0])" > cptest_data
WORKDIR /Grid2Op
RUN tail -n 1 /cptest_data | xargs cp -R grid2op/data_test
RUN rm /cptest_data
WORKDIR /

# Make port 80 available to the world outside this container
EXPOSE 80