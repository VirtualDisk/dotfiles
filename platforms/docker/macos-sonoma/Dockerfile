FROM docker.io/sickcodes/docker-osx:master
ENV USER=root
ENV GENERATE_UNIQUE=true
ENV CPU='Haswell-noTSX'
ENV CPUID_FLAGS='kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on'
ENV MASTER_PLIST_URL='https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom-sonoma.plist'
ENV SHORTNAME=tahoe
ENV DISPLAY="${DISPLAY:-:0}"
WORKDIR /Users/user/.dotfiles
COPY . /Users/user/.dotfiles
ENTRYPOINT ["bash"]
