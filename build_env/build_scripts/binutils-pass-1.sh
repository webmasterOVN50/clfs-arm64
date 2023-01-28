echo  "Inside binutils"
echo 
echo "Starting Binutils installations..."
echo
sleep 1

cd $LFS/sources
tar -xf binutils-2.40.tar.xz
cd binutils-2.40

#bad_command_name

mkdir -v build && cd build

../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror

make 

make install

sleep 1 

cd $LFS/sources
rm -rf binutils-2.40

sleep 1

echo "Done!"