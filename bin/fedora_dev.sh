# based on Fedora 29 server minimal (net) install

dnf -y update

dnf -y install \
    ShellCheck \
    acl \
    acpi \
    aspell \
    atop \
    attr \
    audit \
    autoconf \
    automake \
    bash \
    bat \
    bc \
    bind-utils \
    binutils \
    bison \
    blktrace \
    bpftrace \
    bridge-utils \
    bzip2 \
    cmake \
    colordiff \
    coreutils \
    cpio \
    cpp \
    cppcheck \
    cpuid \
    ctags \
    curl \
    debootstrap \
    device-mapper \
    diffstat \
    diffutils \
    dmidecode \
    dsniff \
    elfutils \
    entr \
    ethtool \
    expect \
    fakeroot \
    file \
    findutils \
    fio \
    flex \
    fping \
    ftp \
    gawk \
    gcc \
    gcc-c++ \
    gdb \
    GeoIP \
    git \
    glibc \
    glibc-devel \
    glibc-headers \
    gnupg2 \
    grep \
    gzip \
    hdparm \
    hexedit \
    hostname \
    hping3 \
    htop \
    iftop \
    info \
    inotify-tools \
    iotop \
    ipcalc \
    iproute \
    iptables \
    iptstate \
    iptraf-ng \
    iputils \
    jq \
    kernel-debug-devel \
    kernel-devel \
    kernel-headers \
    kernel-tools \
    less \
    lftp \
    libcap-ng-utils \
    libcgroup-tools \
    libxml2 \
    logrotate \
    lsof \
    ltrace \
    m4 \
    make \
    man-pages \
    mawk \
    mdadm \
    mercurial \
    mlocate \
    mtr \
    nasm \
    ncdu \
    net-snmp-utils \
    net-tools \
    nftables \
    ngrep \
    nicstat \
    nmap \
    nmap-ncat \
    numactl \
    ntpdate \
    openssh-clients \
    openssh-server \
    openssl \
    parallel \
    parted \
    patch \
    pciutils \
    pcre-tools \
    perf \
    perl \
    pigz \
    policycoreutils \
    policycoreutils-python-utils \
    procps-ng \
    proxychains-ng \
    psacct \
    psmisc \
    pv \
    pyflakes \
    python3 \
    python3-beautifulsoup4 \
    python3-ipython \
    python3-matplotlib \
    python3-mypy \
    python3-notebook \
    python3-numpy \
    python3-pandas \
    python3-requests \
    python3-scapy \
    python3-scipy \
    python3-scrapy \
    python3-seaborn \
    python3-sympy \
    recode \
    ripgrep \
    rpm \
    rsync \
    schedtool \
    sed \
    setools-console \
    socat \
    splint \
    sqlite \
    strace \
    stress \
    stunnel \
    sudo \
    sysstat \
    systemd-container \
    tar \
    tcpdump \
    time \
    tmux \
    traceroute \
    tree \
    unzip \
    util-linux \
    valgrind \
    vim \
    vmtouch \
    weechat \
    wget \
    which \
    whois \
    wireshark-cli \
    zip \
    zsh

# Remove garbage
#dnf remove -y \
#    open-vm-tools \
#    polkit \
#    sssd\* \
#    trousers

# Stop and disable firewalld
# systemctl stop firewalld
# systemctl disable firewalld

# Change installonly_limit
# vi /etc/dnf/dnf.conf

# Setup containers
# dnf install --releasever=30 --installroot=/var/lib/machines/f30-base --disablerepo="*" --enablerepo=fedora,updates fedora-release systemd dnf passwd vim-minimal
# echo >> /etc/fstab
# echo '# overlay filesystems for containers in /var/lib/machines' >> /etc/fstab
# echo 'overlay /var/lib/machines/mysql overlay noauto,lowerdir=/var/lib/machines/f30-base,upperdir=/var/lib/machines/mysql,workdir=/var/lib/machines/.workdir/mysql 0 0' >> /etc/fstab

# change SELinux mode to permissive
# vi /etc/selinux/config

# install kernel-debuginfo
# dnf -y debuginfo-install kernel-debuginfo
