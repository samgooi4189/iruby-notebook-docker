FROM debian:9

MAINTAINER Liang Zheng Gooi <samgooi4189@gmail.com>

# Install base template
RUN apt-get update && apt-get install -y gpg curl procps git sudo

# Create user and add to sudo
RUN useradd -m -d /home/sciruby -s /bin/bash -U sciruby
RUN usermod -a -G sciruby sciruby
RUN echo 'sciruby ALL=NOPASSWD: ALL' >> /etc/sudoers
RUN passwd -d sciruby  # Remove user password
ENV HOME /home/sciruby
USER sciruby

# Install jupyter notebook
RUN sudo apt-get update && sudo apt-get install -y python3-dev python3-pip python-virtualenv libzmq3-dev libtool libtool-bin
RUN pip3 install jupyter

# create a workspace for notebook
RUN mkdir $HOME/workspace

# Install ruby and gems
RUN gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN (curl -sSL https://get.rvm.io | bash)
RUN /bin/bash -l -c "source /home/sciruby/.rvm/scripts/rvm && rvm install 2.5"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN sudo apt-get install libtool libffi-dev make libzmq3-dev libczmq-dev -y
RUN echo "export PATH=\"$PATH:$HOME/.local/bin\"" >> $HOME/.bashrc
RUN echo "[[ -s \"$HOME/.rvm/scripts/rvm\" ]] && . \"$HOME/.rvm/scripts/rvm\"" >> $HOME/.bashrc

# Adding Gemfile to container
COPY --chown=sciruby workspace $HOME/workspace
RUN cd $HOME/workspace && /bin/bash -l -c "bundle install"
RUN /bin/bash -l -c "iruby register --force"

# start jupyter notebook
EXPOSE 8888
ENV PATH $PATH:$HOME/.local/bin
ENV GEM_PATH=$HOME/.rvm/gems/ruby-2.5.1/gems
WORKDIR "$HOME/workspace"
CMD jupyter notebook --NotebookApp.token='' --ip=0.0.0.0 --port=8888 --no-browser
