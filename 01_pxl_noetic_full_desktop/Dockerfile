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
                git vim tmux nano htop sudo curl wget gnupg2 \
                iputils-ping \
                apt-transport-https \
                ca-certificates \
                openssh-server \
                exuberant-ctags \
                bash-completion \
                libcanberra-gtk3-0 \
                graphviz graphviz-dev \
                ros-noetic-gmapping ros-noetic-slam-gmapping ros-noetic-openslam-gmapping \
                ros-noetic-socketcan-interface ros-noetic-soem ros-robot-state-publisher \
                ros-noetic-effort-controllers ros-noetic-moveit ros-noetic-ompl \
                ros-noetic-moveit-visual-tools ros-noetic-rosparam-shortcuts \
                ros-noetic-moveit-resources-prbt-moveit-config ros-noetic-ros-numpy \
                python3-empy python3-collada python-is-python3 python3-pip ipython3 \
                python3-tk \
        && rm -rf /var/lib/apt/lists/* \
        && useradd -ms /bin/bash user \
        && echo "user:user" | chpasswd && adduser user sudo \
        && echo "user ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers

# The OSRF contianer didn't link python3 to python, causing ROS scripts to fail.
RUN ln -s /usr/bin/ipython3 /usr/bin/ipython

# install tools not in apt
RUN pip3 install -U powerline-shell
RUN pip3 install numpy
RUN pip3 install scipy
RUN pip3 install colorcet
RUN pip3 install seaborn
RUN pip3 install tqdm
RUN pip3 install pandas
RUN pip3 install scikit_image
RUN pip3 install pygraphviz
RUN pip3 install open3d
RUN pip3 install opencv_python
RUN pip3 install pybullet
RUN pip3 install rospkg
RUN pip3 install transformations
RUN pip3 install objgraph
RUN pip3 install memory_profiler
RUN pip3 install scikit-guess
RUN pip3 install rtree
RUN pip3 install pydot
RUN pip3 install -U networkx
RUN pip3 install empy
RUN pip3 install glfw
RUN pip3 install scipy
RUN pip3 install open3d
RUN pip3 install toppra
RUN pip3 install trimesh
RUN pip3 install seaborn
RUN pip3 install colorcet
RUN pip3 install pygraphviz
RUN pip3 install pyransac3d
RUN pip3 install transformations
RUN pip3 install mujoco
RUN pip3 install dm_control
RUN pip3 install mujoco-python-viewer
# RUN pip3 install urdfpy
RUN pip3 install https://github.com/MiaoDragon/urdfpy/archive/refs/heads/master.zip
RUN pip3 install git+https://github.com/DanManN/mesh2sdf



USER user
WORKDIR /home/user
RUN sudo usermod -a -G video user

RUN git clone https://github.com/atenpas/gpd \
        && cd gpd \
        && mkdir build \
        && cd build \
        && cmake .. \
        && make -j 8 \
        && sudo make install

RUN git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack  \
        && git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux-resurrect \
        && git clone https://github.com/tmux-plugins/tmux-pain-control ~/.tmux-pain-control
COPY --chown=user:user ./.tmux.conf /home/user/.tmux.conf
COPY --chown=user:user ./.powerline.sh /home/user/.powerline.sh

COPY --chown=user:user ./.vim /home/user/.vim
COPY --chown=user:user ./.vimrc /home/user/.vimrc
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
 
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
