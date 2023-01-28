echo  "Inside glbc script"
echo 
echo "Starting glibc installation ... "
echo
sleep 1

cd $LFS/sources
tar -xf glibc-2.36.tar.xz
cd glibc-2.36

case $(uname -m) in
        arm) ln -sfv ld-linux-armhf.so.3 $LFS/lib/ld-lsb.so.3
             ;;
    aarch64) ln -sfv ../lib/ld-linux-aarch64.so.1 $LFS/lib64
             ln -sfv ../lib/ld-linux-aarch64.so.1 $LFS/lib64/ld-lsb-aarch64.so.3
             ;;
esac

sed '/MAKEFLAGS :=/s/)r/) -r/' -i Makerules

patch -Np1 -i ../glibc-2.36-fhs-1.patch
 
mkdir -v build && cd build

echo "rootsbindir=/usr/sbin" > configparms
 
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=5.4                \
      --with-headers=$LFS/usr/include    \
      libc_cv_slibdir=/usr/lib

make

make DESTDIR=$LFS install

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

sleep 5

echo 
echo "TESTING GLIBC"
echo
echo 'int main(){}' | $LFS_TGT-gcc -xc -
readelf -l a.out | grep ld-linux

rm -v a.out

$LFS/tools/libexec/gcc/$LFS_TGT/12.2.0/install-tools/mkheaders

sleep 5

cd $LFS/sources
rm -rf glibc-2.36

echo "Done!"