# Pull base image.
FROM fedora:31
MAINTAINER Thibault Payet "mailoo.org"

# Install.
RUN dnf -y upgrade

RUN dnf -y install cmake
RUN dnf -y install meson
RUN dnf -y install ninja-build
RUN dnf -y install gcc
RUN dnf -y install pkgconf
RUN dnf -y install pkgconf-pkg-config
RUN dnf -y install git

RUN dnf -y install mingw64-libepoxy
RUN dnf -y install mingw64-SDL2
RUN dnf -y install mingw64-boost
RUN dnf -y install mingw64-binutils
RUN dnf -y install mingw64-eigen3
RUN dnf -y install mingw64-gcc
RUN dnf -y install mingw64-gcc-c++
RUN dnf -y install mingw64-xerces-c

RUN dnf -y install mingw64-gmp
RUN dnf -y install mingw64-mpfr

RUN git clone https://github.com/CGAL/cgal cgal --branch releases/CGAL-4.14.2 && \
mkdir build-mingw64-cgal && \
cd build-mingw64-cgal && \
mingw64-cmake ../cgal -GNinja -DWITH_CGAL_QT5=OFF -DCMAKE_CROSSCOMPILING=TRUE -DCMAKE_CROSSCOMPILING_EMULATOR=wine && \
ninja && \
ninja install && \
cd ..

RUN git clone https://github.com/mariusmuja/flann flann --branch 1.9.1

RUN mkdir build-mingw64-flann && \
cd build-mingw64-flann && \
mingw64-cmake ../flann -GNinja -DBUILD_SHARED=TRUE -DBUILD_PYTHON_BINDINGS=FALSE -DBUILD_MATLAB_BINDINGS=FALSE -DBUILD_EXAMPLES=FALSE -DBUILD_DOC=FALSE -DBUILD_TESTS=FALSE -DUSE_OPENMP=FALSE && \
ninja && \
ninja install && \
cd ..

RUN dnf install -y mingw64-libgomp

RUN dnf install -y mingw64-libpng
RUN dnf install -y mingw64-libtiff
RUN dnf install -y mingw64-wpcap
RUN dnf install -y mingw64-expat

RUN dnf install -y autoconf
RUN dnf install -y automake
RUN dnf install -y libtool

RUN git clone https://github.com/open-mpi/hwloc hwloc --branch hwloc-2.0.4 && \
cd hwloc && \
./autogen.sh && \
mingw64-configure --disable-dependency-tracking && \
make && \
make install && \
cd ..


#RUN git clone https://github.com/PointCloudLibrary/pcl pcl --branch pcl-1.9.1 && \
#mkdir build-mingw64-pcl && \
#cd build-mingw64-pcl && \
#mingw64-cmake ../pcl -GNinja -DPCL_SHARED_LIBS=TRUE -DWITH_LIBUSB=FALSE -DWITH_VTK=FALSE -DWITH_QT=FALSE -DCMAKE_CROSSCOMPILING=TRUE -DCMAKE_CROSSCOMPILING_EMULATOR=wine && \
#ninja && \
#ninja install && \
#cd ..


#RUN git clone https://github.com/STEllAR-GROUP/hpx hpx --branch 1.3.9 && \
#mkdir build-mingw64-hpx && \
#cd build-mingw64-hpx && \
#mingw64-cmake ../hpx -GNinja && \
#ninja && \
#ninja install && \
#cd ..
