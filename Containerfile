FROM quay.io/fedora/fedora-bootc:45

# Enable RPM Fusion free for freeworld VA-API/VDPAU drivers
RUN dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    && dnf clean all

# Install build dependencies and packages
RUN dnf -y install \
    git \
    pkgconf \
    conky \
    words \
    nftables \
    feh \
    fuse \
    fuse-libs \
    steam-devices \
    libglvnd-opengl \
    libxcrypt-compat \
    libxkbcommon-x11 \
    libnsl \
    NetworkManager-wifi \
    wpa_supplicant \
    iw \
    wireless-regdb \
    android-tools \
    libnotify \
    glibc-langpack-en \
    gtk3 \
    atk \
    at-spi2-atk \
    at-spi2-core \
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
    alacritty \
    xclip \
    xset \
    alsa-utils \
    alsa-lib \
    mesa-dri-drivers \
    mesa-va-drivers \
    # mesa-va-drivers-freeworld \
    libva \
    libva-utils \
    glx-utils \
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

# Configure logind to ignore lid switch
RUN mkdir -p /etc/systemd/logind.conf.d && \
    printf '[Login]\nHandleLidSwitch=ignore\nHandleLidSwitchExternalPower=ignore\nHandleLidSwitchDocked=ignore\n' \
    > /etc/systemd/logind.conf.d/ignore-lid.conf && \
    systemctl enable systemd-logind.service

# Configure nftables firewall
RUN systemctl enable nftables.service
COPY nftables.conf /etc/sysconfig/nftables.conf

# Create bound-images
RUN mkdir -p /usr/lib/bootc/bound-images.d

# RSSHub as a logically-bound Quadlet
COPY rsshub.container /usr/share/containers/systemd/rsshub.container
RUN ln -s /usr/share/containers/systemd/rsshub.container \
    /usr/lib/bootc/bound-images.d/rsshub.container

# Cloudflared as a logically-bound Quadlet
COPY cloudflared.container /usr/share/containers/systemd/cloudflared.container
RUN ln -s /usr/share/containers/systemd/cloudflared.container \
    /usr/lib/bootc/bound-images.d/cloudflared.container

# Jackett as a logically-bound Quadlet
COPY jackett.container /usr/share/containers/systemd/jackett.container
RUN ln -s /usr/share/containers/systemd/jackett.container \
    /usr/lib/bootc/bound-images.d/jackett.container

# Emacs as a logically-bound Quadlet
COPY emacs.container /usr/share/containers/systemd/emacs.container
RUN ln -s /usr/share/containers/systemd/emacs.container \
    /usr/lib/bootc/bound-images.d/emacs.container

# Lint the image
RUN bootc container lint
