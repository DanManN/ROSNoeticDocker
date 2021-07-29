FROM osrf/ros:noetic-desktop-full-focal
# The OSRF ROS Noetic containers use the root user.
# Therefore, the following commands are executed as root up until the
# USER user statement.

# We love UTF!
ENV LANG C.UTF-8

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Set the nvidia container runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Install some handy tools.
RUN set -x \
        && apt-get update \
        && apt-get --with-new-pkgs upgrade -y \
        && apt-get install -y software-properties-common \
        && add-apt-repository ppa:rock-core/qt4 \
        && apt-get install -y mesa-utils qt4-default libspnav0 \
        && apt-get install -y iputils-ping \
        && apt-get install -y apt-transport-https ca-certificates \
        && apt-get install -y openssh-server exuberant-ctags \
        && apt-get install -y git vim tmux nano htop sudo curl wget gnupg2 \
        && apt-get install -y bash-completion \
        && apt-get install -y libcanberra-gtk3-0 \
        && apt-get install -y ros-noetic-gmapping ros-noetic-slam-gmapping ros-noetic-openslam-gmapping \
        && apt-get install -y ros-noetic-effort-controllers ros-noetic-moveit ros-noetic-ompl ros-noetic-moveit-visual-tools ros-noetic-rosparam-shortcuts \
        && apt-get install -y ros-noetic-socketcan-interface ros-noetic-soem ros-robot-state-publisher \
        && apt-get install -y python3-empy python3-collada python-is-python3 python3-pip ipython3 python3-numpy python3-scipy \
        && pip3 install powerline-shell  \
        && rm -rf /var/lib/apt/lists/* \
        && useradd -ms /bin/bash user \
        && echo "user:user" | chpasswd && adduser user sudo \
        && echo "user ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers

# The OSRF contianer didn't link python3 to python, causing ROS scripts to fail.
RUN ln -s /usr/bin/ipython3 /usr/bin/ipython

# install tools not in apt
RUN pip install trimesh

USER user
WORKDIR /home/user
RUN sudo usermod -a -G video user

RUN git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack  \
        && git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux-resurrect \
        && git clone https://github.com/tmux-plugins/tmux-pain-control ~/.tmux-pain-control
COPY --chown=user:user ./.tmux.conf /home/user/.tmux.conf
COPY --chown=user:user ./.powerline.sh /home/user/.powerline.sh

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

COPY --chown=user:user ./.vimrc /home/user/.vimrc
 
RUN set -x \
        && vim -E -u NONE -S /home/user/.vimrc -C "+PlugInstall" -C "+qall";  exit 0
#
# Set some decent colors if the container needs to be accessed via /bin/bash.
RUN echo LS_COLORS=$LS_COLORS:\'di=1\;33:ln=36\' >> ~/.bashrc \
        && echo export LS_COLORS >> ~/.bashrc \
        && echo 'source ~/.powerline.sh' >> ~/.bashrc \
        && echo 'alias tmux="tmux -2"' >> ~/.bashrc \
        && echo 'PATH=~/bin:$PATH' >> ~/.bashrc \
        && touch ~/.sudo_as_admin_successful # To surpress the sudo message at run.

RUN rosdep update \
        && echo "source /opt/ros/noetic/setup.bash" >> /home/user/.bashrc

RUN mkdir -p Projects/
# RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /home/user/Projects/catkin_ws; catkin_make'
# RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /home/user/Projects/catkin_ws; catkin_make'

# RUN echo "source /home/user/Projects/catkin_ws/devel/setup.bash --extend" >> /home/user/.bashrc
STOPSIGNAL SIGTERM

CMD sudo service ssh start && /bin/bash
