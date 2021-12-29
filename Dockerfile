FROM ros:melodic

LABEL description="ROS melodic image with circleci tools installed"
LABEL maintainer="Yu-Wen Chen"

ENV ROS_DISTRO=melodic
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

WORKDIR /ws

RUN apt-get update && apt-get install -y \
  git \
  ssh \
  tar \
  gzip \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
RUN apt-get update
RUN apt-get install python3-catkin-tools -y

RUN mkdir src && \
    cd src && git clone https://github.com/airuchen/geonav_transform.git && cd .. && \
    rosdep install --from-paths src --ignore-src -r -y
RUN catkin config --extend ${ROS_ROOT}
# COPY ./setup.bash /ros_entrypoint.sh
# RUN echo 'source /opt/ros/${ROS_DISTRO}/setup.bash' >> /root/.bashrc
# ENTRYPOINT ["/ros_entrypoint.sh"]
# CMD ["bash"]
RUN catkin build

