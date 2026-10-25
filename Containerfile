FROM quay.io/fedora/fedora-bootc:45

# Install build dependencies and packages
RUN dnf -y install \
    git \
    gcc \
    make \
    autoconf \
    automake \
    libtool \
    pkgconf \
    libX11-devel \
    speed-dreams \
    emacs-nw \
    antimicrox \
    onionshare \
    torbrowser-launcher \
    android-tools \
    cloudflared \
    libnotify \
    dillo \
    dunst \
    firejail \
    shotgun \
    7zip \
    pciutils \
    util-linux \
    wget \
    curl \
    sudo \
    which \
    jq \
    libXext-devel \
    libXinerama-devel \
    libXrandr-devel \
    libXft-devel \
    dmenu \
    xorg-x11-server-Xorg \
    xorg-x11-xinit \
    xterm \
    xclip \
    alsa-utils \
    && dnf clean all

# Build custom ratpoison 1.4.10-beta from git
RUN git clone https://git.savannah.nongnu.org/git/ratpoison.git /tmp/ratpoison && \
    cd /tmp/ratpoison && \
    git checkout a34577dd8662d2cb3f617e187f9f60288d71ccbd && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    rm -rf /tmp/ratpoison

# Build and install keyd from source
RUN git clone --depth=1 https://github.com/rvaiya/keyd.git /tmp/keyd && \
    cd /tmp/keyd && \
    make && \
    make install && \
    rm -rf /tmp/keyd

# Enable keyd
RUN systemctl enable keyd

# Copy keyd config (matching your Nix setup)
COPY configs/keyd-default.conf /etc/keyd/default.conf

# Basic X11 / ratpoison setup
# Create a simple .xinitrc or session for ratpoison
RUN mkdir -p /etc/X11/xinit && \
    echo 'exec ratpoison' > /etc/X11/xinit/xinitrc

# Lint the image
RUN bootc container lint
