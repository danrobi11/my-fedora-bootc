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

# Install custom ratpoison binary
RUN mkdir -p /usr/local/bin && \
    curl -fsSL -o /usr/local/bin/ratpoison \
      https://github.com/danrobi11/my-ratpoison/releases/latest/download/ratpoison && \
    chmod +x /usr/local/bin/ratpoison

# Basic X11 / ratpoison setup
RUN mkdir -p /etc/X11/xinit && \
    echo 'exec ratpoison' > /etc/X11/xinit/xinitrc

# Enable wpa_supplicant
RUN mkdir -p /etc/systemd/system/multi-user.target.wants && \
    ln -sf /usr/lib/systemd/system/wpa_supplicant.service \
           /etc/systemd/system/multi-user.target.wants/wpa_supplicant.service

# Download and install StevenBlack hosts
RUN mkdir -p /usr/local/share && \
    curl -fsSL -o /usr/local/share/hosts.stevenblack \
      https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts && \
    cp -f /usr/local/share/hosts.stevenblack /etc/hosts

# Allow X to start from console
RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

# Lint the image
RUN bootc container lint
