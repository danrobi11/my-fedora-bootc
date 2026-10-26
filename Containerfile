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
    texinfo \
    emacs-nw \
    antimicrox \
    mpv \
    vlc \
    conky \
    feh \
    NetworkManager-wifi \
    wpa_supplicant \
    iw \
    wireless-regdb \
    firefox \
    onionshare \
    torbrowser-launcher \
    android-tools \
    libnotify \
    dillo \
    dunst \
    firejail \
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
    libXt-devel \
    xorg-x11-proto-devel \
    pkgconf-pkg-config \
    scrot \
    dmenu \
    xorg-x11-server-Xorg \
    xorg-x11-xinit \
    xterm \
    xclip \
    xset \
    alsa-utils \
    && dnf clean all

# Build custom ratpoison
RUN git clone --depth=1 https://git.savannah.nongnu.org/git/ratpoison.git /tmp/ratpoison && \
    cd /tmp/ratpoison && \
    git fetch --depth=1 origin a34577dd8662d2cb3f617e187f9f60288d71ccbd && \
    git checkout a34577dd8662d2cb3f617e187f9f60288d71ccbd && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-debug && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/ratpoison

# Basic X11 / ratpoison setup
RUN mkdir -p /etc/X11/xinit && \
    echo 'exec ratpoison' > /etc/X11/xinit/xinitrc

# Enable wpa_supplicant
RUN mkdir -p /etc/systemd/system/multi-user.target.wants && \
    ln -sf /usr/lib/systemd/system/wpa_supplicant.service \
           /etc/systemd/system/multi-user.target.wants/wpa_supplicant.service

# Allow X to start from console
RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

# Lint the image
RUN bootc container lint
