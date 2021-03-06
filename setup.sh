#!/bin/bash

set -euxo pipefail

# Scala dependencies
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add

sudo add-apt-repository universe

# Update and upgrade
sudo apt-get update
sudo apt-get upgrade -y

# Essential packages
sudo apt install -y \
				autoconf \
				autogen \
				automake \
				autotools-dev \
				bc \
				binutils \
				binutils-dev \
				bison \
				build-essential \
				clang \
				cloc \
				cmake \
				cmake-curses-gui \
				curl \
				default-jdk \
				device-tree-compiler \
				flex \
				gawk \
				gcc \
				gcc-multilib \
				gdb \
				gdb-multiarch \
				git \
				gperf \
				gzip \
			 	libexpat-dev \
				libfdt-dev \
				libglib2.0-dev \
				libgmp-dev \
				libmpc-dev \
				libmpfr-dev \
				libncurses5 \
				libssl-dev \
				libtool \
				libpixman-1-dev \
				libusb-1.0-0-dev \
				linux-headers-$(uname -r) \
				linux-tools-common \
				linux-tools-generic \
				llvm \
				llvm-dev \
				ltrace \
				ncurses-dev \
				ninja-build \
				nmap \
				openssl \
				patchutils \
			 	pkg-config \
				python \
				python3-dev \
				python3-pip \
				python-matplotlib \
				python-networkx \
				python-pygraphviz \
				python-serial \
				qemu \
			 	sbt \
				sed \
				snapd \
				texinfo \
				tcl \
				tmux \
				vbindiff \
				vim \
				wget \
				xclip \
				zip \
				zlib1g-dev

# Snapd install
sudo snap install code --classic

# Desktop configuration
mkdir ~/local-opt
cp functions ~/local-opt/
cp aliases ~/local-opt/

# Vim configuration
cp .vimrc ~/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cat >> ~/.vimrc << EOF
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
EOF
# Installing plugins
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
# YCM plugin default C/C++ config
cp .ycm_extra_conf.py ~/.vim/plugged/youcompleteme/.ycm_extra_conf.py

# Zsh configuration
sudo apt-get install -y zsh powerline fonts-powerline
chsh -s /bin/zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
sed -i 's/robbyrussell/agnoster/g' ~/.zshrc
sed -i 's/source.*oh-my-zsh.sh/DISABLE_MAGIC_FUNCTIONS=true\n&/' ~/.zshrc

# Keyboard
cat >> ~/.zshrc << EOF
setxkbmap fr
EOF

# Custom aliases
cat >> ~/.zshenv << EOF
source ~/local-opt/aliases
EOF

# Custom functions
cat >> ~/.zshenv << EOF
source ~/local-opt/functions
EOF

# Custom aliases
cat >> ~/.bashrc << EOF
source ~/local-opt/aliases
EOF

# Custom functions
cat >> ~/.bashrc << EOF
source ~/local-opt/functions
EOF

# Powerline
git clone https://github.com/powerline/fonts.git && (cd fonts && sh ./install.sh)
cat >> ~/.zshrc << EOF
if [ -f /usr/share/powerline/bindings/zsh/powerline.sh ]; then
  source /usr/share/powerline/bindings/zsh/powerline.sh
fi
EOF

# Tmux configuration
# Customize tmux
cat >> ~/.tmux.conf << EOF
set-option -g mouse off
set-option -g history-limit 5000
set-option -g status-bg colour231
source "/usr/share/powerline/bindings/tmux/powerline.conf"
EOF

# Python 2
curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
sudo python get-pip.py

# STM Tools
wget https://github.com/stlink-org/stlink/releases/download/v1.6.1/stlink-1.6.1-1_amd64.deb
sudo apt install ./stlink-1.6.1-1_amd64.deb

# Do some cleaning
sudo apt-get autoremove -y
