FROM quay.io/fedora/fedora-bootc:45

# Enable RPM Fusion free
# RUN dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm && dnf clean all

RUN dnf -y remove \
    adobe-mappings-cmap \
    adobe-mappings-cmap-deprecated \
    adobe-mappings-pdf \
    atheros-firmware \
    net-tools \
    xdg-desktop-portal \
    geoclue2 \
    libcloudproviders \
    localsearch \
    sssd-ad \
    sssd-client \
    sssd-common \
    sssd-ipa \
    sssd-krb5 \
    sssd-ldap \
    adcli \
    adcli-selinux \
    cirrus-audio-firmware \
    intel-audio-firmware \
    intel-gpu-firmware \
    intel-npu-firmware \
    intel-mediasdk \
    intel-vpl-gpu-rt \
    bluez-libs \
    pipewire \
    wireplumber \
    wireplumber-libs \
    pipewire-jack-audio-connection-kit \
    pipewire-jack-audio-connection-kit-libs \
    pipewire-libs \
    pipewire-plugin-libcamera \
    pipewire-pulseaudio \
    pipewire-alsa \
    pulseaudio-libs \
    nvidia-gpu-firmware \
    gstreamer1 \
    gstreamer1-plugins-base \
    flatpak-session-helper \
    libcanberra \
    libcanberra-backend-alsa \
    libcanberra-backend-gstreamer \
    libcanberra-backend-pulse \
    libcanberra-gtk3 \
    tiwilink-firmware \
    libaribcaption \
    vim-data \
    vim-minimal \
    brcmfmac-firmware \
    # here
    cloud-utils-growpart \
    && dnf clean all

# Install build dependencies and packages
RUN dnf -y install \
    --exclude=cloud-utils-growpart \
    --exclude=libaribcaption \
    --exclude=libcloudproviders \
    --exclude=pulseaudio-libs \
    --exclude=flatpak-session-helper \
    --exclude=gstreamer1 \
    --exclude=gstreamer1-plugins-base \
    --exclude=libcanberra \
    --exclude=libcanberra-backend-alsa \
    --exclude=libcanberra-backend-gstreamer \
    --exclude=libcanberra-backend-pulse \
    --exclude=libcanberra-gtk3 \
    --exclude=intel-mediasdk \
    --exclude=intel-vpl-gpu-rt \
    --exclude=bluez-libs \
    --exclude=pipewire \
    --exclude=wireplumber \
    --exclude=wireplumber-libs \
    --exclude=pipewire-jack-audio-connection-kit \
    --exclude=pipewire-jack-audio-connection-kit-libs \
    --exclude=pipewire-libs \
    --exclude=pipewire-plugin-libcamera \
    --exclude=pipewire-pulseaudio \
    --exclude=pipewire-alsa \
    git \
    pkgconf \
    # conky \
    words \
    nftables \
    # feh \
    fuse \
    fuse-libs \
    # steam-devices \
    # flatpak \

    # for who?
    # libxcrypt-compat \
    # libnsl \

    # for neomacs
    # libxkbcommon-x11 \

    # for cpak
    # xorg-x11-server-Xephyr \

    # for antimicrox
    # libglvnd-opengl \

    # lib for torrent digger
    # webkit2gtk4.1 \

    bootc \
    bubblewrap \
    containers-common-extra \
    NetworkManager-wifi \
    wpa_supplicant \
    iw \
    wireless-regdb \
    android-tools \
    libnotify \
    glibc-langpack-en \

    # For Browsers
    gtk3 \
    atk \
    at-spi2-atk \
    google-noto-emoji-color-fonts \

    7zip \
    pciutils \
    util-linux \
    wget \
    curl \
    sudo \
    which \
    jq \

    # for ratpoison
    libXtst \

    # scrot \
    dmenu \
    xorg-x11-server-Xorg \
    xorg-x11-xinit \
    xterm \
    # alacritty \
    xclip \
    xset \
    xrandr \
    alsa-utils \
    alsa-lib \

    # lib for q3rally
    # sdl2-compat \

    # videos
    # mesa-dri-drivers \
    # mesa-va-drivers \
    # libva \
    # libva-utils \
    # glx-utils \
    gsettings-desktop-schemas \
    cups-libs \
    cups-filesystem \
    aardvark-dns \
    podman \
    abseil-cpp \
    fribidi \
    tinysparql \
    libtinysparql \
    crypto-policies \
    crypto-policies-scripts \
    cryptsetup \
    cryptsetup-libs \
    && dnf clean all

# Needed libs
#

# # Install custom ratpoison binary
# RUN mkdir -p /usr/local/bin && \
#     curl -fsSL -o /usr/local/bin/ratpoison \
#     https://github.com/danrobi11/my-ratpoison/releases/latest/download/ratpoison && \
#     chmod +x /usr/local/bin/ratpoison
# 
# # Basic X11 / ratpoison setup
# RUN mkdir -p /etc/X11/xinit && \
#     echo 'exec ratpoison' > /etc/X11/xinit/xinitrc

# Allow X to start from console
RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

# Disable automatic bootc updates/reboots
RUN systemctl mask bootc-fetch-apply-updates.timer

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
# RUN mkdir -p /usr/lib/bootc/bound-images.d

# # RSSHub as a logically-bound Quadlet
# COPY rsshub.container /usr/share/containers/systemd/rsshub.container
# RUN ln -s /usr/share/containers/systemd/rsshub.container \
    # /usr/lib/bootc/bound-images.d/rsshub.container

# # Cloudflared as a logically-bound Quadlet
# COPY cloudflared.container /usr/share/containers/systemd/cloudflared.container
# RUN ln -s /usr/share/containers/systemd/cloudflared.container \
    # /usr/lib/bootc/bound-images.d/cloudflared.container

# # Jackett as a logically-bound Quadlet
# COPY jackett.container /usr/share/containers/systemd/jackett.container
# RUN ln -s /usr/share/containers/systemd/jackett.container \
#     /usr/lib/bootc/bound-images.d/jackett.container
# 
# # Emacs as a logically-bound Quadlet
# COPY emacs.container /usr/share/containers/systemd/emacs.container
# RUN ln -s /usr/share/containers/systemd/emacs.container \
#     /usr/lib/bootc/bound-images.d/emacs.container

# Enable linger for danrobi so rootless user services start at boot
# RUN mkdir -p /var/lib/systemd/linger && \
#     touch /var/lib/systemd/linger/danrobi

# # Rootless Quadlets for UID 1000
# RUN mkdir -p /etc/containers/systemd/users/1000
# # COPY emacs.container /etc/containers/systemd/users/1000/emacs.container
# COPY rsshub.container /etc/containers/systemd/users/1000/rsshub.container
# COPY cloudflared.container /etc/containers/systemd/users/1000/cloudflared.container
# COPY jackett.container /etc/containers/systemd/users/1000/jackett.container

# Lint the image
RUN bootc container lint
