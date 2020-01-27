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

RUN dnf install -y mingw64-libgomp

RUN dnf install -y mingw64-libpng
RUN dnf install -y mingw64-libtiff
RUN dnf install -y mingw64-wpcap
RUN dnf install -y mingw64-expat

RUN dnf install -y autoconf
RUN dnf install -y automake
RUN dnf install -y libtool

RUN dnf install -y make

RUN git clone https://github.com/CGAL/cgal cgal --branch releases/CGAL-4.14.2
RUN mkdir build-mingw64-cgal && \
cd build-mingw64-cgal && \
mingw64-cmake ../cgal -GNinja -DWITH_CGAL_QT5=OFF -DCMAKE_CROSSCOMPILING=TRUE -DCMAKE_CROSSCOMPILING_EMULATOR=wine && \
ninja && \
ninja install && \
cd ..

COPY CGAL.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/


RUN git clone https://github.com/mariusmuja/flann flann --branch 1.9.1

RUN mkdir build-mingw64-flann && \
cd build-mingw64-flann && \
mingw64-cmake ../flann -GNinja -DBUILD_SHARED=TRUE -DBUILD_PYTHON_BINDINGS=FALSE -DBUILD_MATLAB_BINDINGS=FALSE -DBUILD_EXAMPLES=FALSE -DBUILD_DOC=FALSE -DBUILD_TESTS=FALSE -DUSE_OPENMP=FALSE && \
ninja && \
ninja install && \
cd ..


RUN git clone https://github.com/open-mpi/hwloc hwloc --branch hwloc-2.0.4
RUN cd hwloc && \
./autogen.sh && \
mingw64-configure --disable-dependency-tracking && \
make && \
make install | true && \
cd ..

RUN cp hwloc/hwloc.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/
RUN cp hwloc/netloc.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/
RUN cp hwloc/netlocscotch.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/


RUN git clone https://github.com/PointCloudLibrary/pcl pcl --branch pcl-1.10.0

RUN git clone https://github.com/g-truc/glm glm --branch 0.9.9.3

RUN mkdir build-mingw64-glm && \
cd build-mingw64-glm && \
mingw64-cmake ../glm -GNinja -DGLM_TEST_ENABLE=OFF -DCMAKE_CROSSCOMPILING=TRUE -DCMAKE_CROSSCOMPILING_EMULATOR=wine -DCMAKE_BUILD_TYPE=Release && \
ninja && \
ninja install | true && \
cd .. && \
rm -rf build-mingw64-glm

COPY glm.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/



COPY low_level_io.h pcl/io/include/pcl/io/
COPY common_headers.h pcl/common/include/pcl/common
COPY bearing_angle_image.cpp pcl/common/src
COPY common.h pcl/common/include/pcl/common
COPY sac.h pcl/sample_consensus/include/pcl/sample_consensus
COPY pcd_grabber.cpp pcl/io/src
COPY hdl_grabber.h pcl/io/include/pcl/io
COPY io/CMakeLists.txt pcl/io
COPY boundary.h pcl/features/include/pcl/features
COPY moment_of_inertia_estimation.h pcl/features/include/pcl/features
COPY auxiliary.h pcl/recognition/include/pcl/recognition/ransac_based
COPY obj_rec_ransac.h pcl/recognition/include/pcl/recognition/ransac_based
COPY region_growing.h pcl/segmentation/include/pcl/segmentation
COPY permutohedral.h pcl/ml/include/pcl/ml
COPY metrics.h pcl/apps/3d_rec_framework/include/pcl/apps/3d_rec_framework/utils
COPY file_io.h pcl/io/include/pcl/io
COPY auto_io.h pcl/io/include/pcl/io
COPY entropy_range_coder.h pcl/io/include/pcl/compression
COPY eigen.h pcl/common/include/pcl/common
COPY pcl_macros.h pcl/common/include/pcl
COPY bearing_angle_image.h pcl/common/include/pcl/range_image

RUN mkdir build-mingw64-pcl && \
cd build-mingw64-pcl && \
mingw64-cmake ../pcl -GNinja -DPCL_SHARED_LIBS=TRUE -DWITH_LIBUSB=FALSE -DWITH_VTK=FALSE -DWITH_QT=FALSE -DCMAKE_CROSSCOMPILING=TRUE -DCMAKE_CROSSCOMPILING_EMULATOR=wine -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOLS=FALSE && \
ninja && \
ninja install && \
cd .. && \
rm -rf build-mingw64-pcl

#RUN git clone https://github.com/STEllAR-GROUP/hpx hpx --branch 1.3.0 && \
#mkdir build-mingw64-hpx && \
#cd build-mingw64-hpx && \
#HWLOC_ROOT=/usr/x86_64-w64-mingw32/sys-root/mingw/ mingw64-cmake ../hpx -GNinja && \
#ninja && \
#ninja install && \
#cd ..


