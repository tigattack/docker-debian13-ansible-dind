FROM geerlingguy/docker-debian13-ansible:latest


# Install python3-debian
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3-debian \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Allow installing stuff to system Python
RUN find /usr/lib/python3* -name EXTERNALLY-MANAGED -exec rm -v {} + ;

# Upgrade pip to latest version.
# RUN pip3 install --upgrade pip --break-system-packages

# Install Docker
RUN --mount=src=./install_docker.yml,target=/install_docker.yml,type=bind \
    ansible-galaxy role install geerlingguy.docker &&\
    ansible-galaxy role install geerlingguy.pip &&\
    ansible-playbook /install_docker.yml &&\
    rm -rf ~/.ansible/roles /var/lib/apt/lists/* &&\
    apt-get clean
