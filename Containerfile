FROM quay.io/fedora/fedora-bootc:45

# Install build dependencies and packages
RUN dnf -y install \
    git \
    pkgconf \
    emacs-nw \
    fuse \
    conky \
    feh \
    NetworkManager-wifi \
    wpa_supplicant \
    iw \
    wireless-regdb \
    onionshare \
    android-tools \
    libnotify \
    glibc-langpack-en \
    gtk3 \
    atk \
    at-spi2-atk \
    at-spi2-core \
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
    libXtst \
    scrot \
    dmenu \
    xorg-x11-server-Xorg \
    xorg-x11-xinit \
    xterm \
    xclip \
    xset \
    alsa-utils \
    alsa-lib \
    && dnf clean all

# Install custom ratpoison binary
RUN mkdir -p /usr/local/bin && \
    curl -fsSL -o /usr/local/bin/ratpoison \
      https://github.com/danrobi11/my-ratpoison/releases/latest/download/ratpoison && \
    chmod +x /usr/local/bin/ratpoison

# Basic X11 / ratpoison setup
RUN mkdir -p /etc/X11/xinit && \
    echo 'exec ratpoison' > /etc/X11/xinit/xinitrc

# Allow X to start from console
RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

# Enable wpa_supplicant
RUN mkdir -p /etc/systemd/system/multi-user.target.wants && \
    ln -sf /usr/lib/systemd/system/wpa_supplicant.service \
           /etc/systemd/system/multi-user.target.wants/wpa_supplicant.service

# Ensure user is in audio group on boot
COPY ensure-audio-group.sh /usr/local/bin/ensure-audio-group.sh
COPY ensure-audio-group.service /etc/systemd/system/ensure-audio-group.service
RUN chmod +x /usr/local/bin/ensure-audio-group.sh && \
    systemctl enable ensure-audio-group.service

# Lint the image
RUN bootc container lint
