export DIST_ROOT=/home/ubuntu/lxdarm64
export LFS=$DIST_ROOT/build_env/build_root

echo "Dist_Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"

#mkdir -p $LFS/sources && chmod -v a+wt $LFS/sources

#wget https://www.linuxfromscratch.org/lfs/view/stable-systemd/md5sums -P $LFS/sources

for f in $(cat $DIST_ROOT/build_env/listpkgs)
do
        bn=$(basename $f)

        if ! test -f $LFS/sources/$bn ; then
           wget $f -O $LFS/sources/$bn
        fi

done;

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  aarch64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

passwd lfs

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  aarch64) chown -v lfs $LFS/lib64 ;;
esac

su - lfs

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS='-j$(nproc)'
EOF

source ~/.bash_profile

echo "completed prepping server"
 


