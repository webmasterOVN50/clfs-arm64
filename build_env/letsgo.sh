export DIST_ROOT=/home/ubuntu/lxdarm64
export LFS=$DIST_ROOT/build_env/build_root

bad_command_name
echo "Dist_Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"

if ! test $(whoami) == "lfs" ; then
    echo "Must run as lfs!"
    exit -l
fi
 
echo "Creating build environment...."
cd $DIST_ROOT/build_env

#bash -e build_scripts/binutils-pass-1.sh
bash -e build_scripts/gcc-pass-1.sh
#bash -e build_scripts/linux-headers.sh
#bash -e build_scripts/glibc.sh

echo "DONE!"