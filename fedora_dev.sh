#!/bin/bash
# based on Fedora 29 server minimal (net) install

set -ueo pipefail

INSTALL_PACKAGE_GROUP_ADMIN_TOOLS=1
INSTALL_PACKAGE_GROUP_UTILITIES=1
INSTALL_PACKAGE_GROUP_NETWORKING_TOOLS=1
INSTALL_PACKAGE_GROUP_DEVELOPMENT=1
REMOVE_CRUFT_PACKAGES=1
DISABLE_FIREWALLD=1
CHANGE_SELINUX_TO_PERMISSIVE=1
CHANGE_DNF_SETTINGS=1
SETUP_CONTAINERS=1

# administration, hardware, security and tracing tools
if [ "$INSTALL_PACKAGE_GROUP_ADMIN_TOOLS" -eq 1 ]; then
    dnf -y install \
        acl \
        acpi \
        atop \
        attr \
        audit \
        bcc-tools \
        blktrace \
        bpftrace \
        chrony \
        coreutils \
        cpio \
        cpuid \
        debootstrap \
        device-mapper \
        dmidecode \
        fio \
        hdparm \
        hostname \
        htop \
        iotop \
        libcap-ng-utils \
        libcgroup-tools \
        libcgroup-tools \
        logrotate \
        lsof \
        ltrace \
        mdadm \
        numactl \
        ntpdate \
        parted \
        passwd \
        pciutils \
        perf \
        policycoreutils \
        policycoreutils-python-utils \
        procps-ng \
        psacct \
        psmisc \
        rpm \
        schedtool \
        setools-console \
        strace \
        stress \
        sudo \
        sysstat \
        systemd-container \
        tar \
        time \
        util-linux \
        util-linux-user \
        vmtouch \
        xfsprogs
fi

# other tools, not related to administration
if [ "$INSTALL_PACKAGE_GROUP_UTILITIES" -eq 1 ]; then
    dnf -y install \
        aspell \
        bash \
        bat \
        bc \
        bzip2 \
        colordiff \
        diffutils \
        diffstat \
        entr \
        expect \
        fakeroot \
        file \
        findutils \
        gawk \
        grep \
        GeoIP \
        gnupg2 \
        gzip \
        hexedit \
        info \
        inotify-tools \
        ipcalc \
        jq \
        less \
        man-pages \
        mlocate \
        ncdu \
        openssl \
        parallel \
        patch \
        pcre-tools \
        pv \
        recode \
        ripgrep \
        sed \
        sqlite \
        tmux \
        tree \
        unzip \
        vim \
        weechat \
        which \
        zip \
        zsh
fi

# networking related tools, servers and clients
if [ "$INSTALL_PACKAGE_GROUP_NETWORKING_TOOLS" -eq 1 ]; then
    dnf -y install \
        bind-utils \
        bridge-utils \
        curl \
        dhcp-client \
        dsniff \
        ethtool \
        fping \
        ftp \
        hping3 \
        iftop \
        iproute \
        iproute-tc \
        iptables \
        iptstate \
        iptraf-ng \
        iputils \
        lftp \
        mtr \
        net-tools \
        nftables \
        ngrep \
        nicstat \
        nmap \
        nmap-ncat \
        openssh-clients \
        openssh-server \
        proxychains-ng \
        rsync \
        socat \
        stunnel \
        tcpdump \
        traceroute \
        wget \
        whois \
        wireshark-cli
fi

# packages related to development
if [ "$INSTALL_PACKAGE_GROUP_DEVELOPMENT" -eq 1 ]; then
    dnf -y install \
        autoconf \
        automake \
        binutils \
        bison \
        cmake \
        cpp \
        cppcheck \
        ctags \
        elfutils \
        flex \
        gcc \
        gcc-c++ \
        gdb \
        git \
        glibc-devel \
        glibc-headers \
        kernel-debug-devel \
        kernel-devel \
        kernel-headers \
        m4 \
        make \
        mercurial \
        nasm \
        perl \
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
        ShellCheck \
        splint \
        valgrind
fi

# Remove garbage
if [ "$REMOVE_CRUFT_PACKAGES" -eq 1 ]; then
    dnf remove -y \
        open-vm-tools \
        polkit \
        sssd-common \
        sssd-client \
        trousers
fi

# Stop and disable firewalld
if [ "$DISABLE_FIREWALLD" -eq 1 ]; then
    systemctl stop firewalld
    systemctl disable firewalld
fi

# Change installonly_limit
if [ "$CHANGE_DNF_SETTINGS" -eq 1 ]; then
    sed -i.bak -e '/^installonly_limit=/c installonly_limit=2' /etc/dnf/dnf.conf
fi

# change SELinux mode to permissive
if [ "$CHANGE_SELINUX_TO_PERMISSIVE" -eq 1 ]; then
    sed -i.bak -e '/^SELINUX=/c SELINUX=permissive' /etc/selinux/config
    setenforce permissive
fi

# Setup containers dirs and templates
if [ "$SETUP_CONTAINERS" -eq 1 ]; then
    if [ ! -d /var/lib/machines/f30-base ]; then
        dnf -y install --releasever=30 --installroot=/var/lib/machines/f30-base --disablerepo="*" --enablerepo=fedora,updates fedora-release systemd dnf passwd vim-minimal
        # echo >> /etc/fstab
        # echo '# overlay filesystems for containers in /var/lib/machines' >> /etc/fstab
        # echo 'overlay /var/lib/machines/mysql overlay noauto,lowerdir=/var/lib/machines/f30-base,upperdir=/var/lib/machines/mysql,workdir=/var/lib/machines/.workdir/mysql 0 0' >> /etc/fstab
    fi
fi

# install kernel-debuginfo
# dnf -y debuginfo-install kernel-debuginfo
