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

RUN dnf install -y gcc-c++

#RUN git clone https://github.com/PointCloudLibrary/pcl pcl --branch pcl-1.10.0

RUN dnf install -y glm-devel && \
ln -s /usr/include/glm /usr/x86_64-w64-mingw32/sys-root/mingw/include/glm

#RUN git clone https://github.com/g-truc/glm glm --branch 0.9.8.5 && \
#mkdir build-mingw64-glm && \
#cd build-mingw64-glm && \
#mingw64-cmake ../glm -GNinja -DGLM_TEST_ENABLE=OFF -DCMAKE_CROSSCOMPILING=TRUE -DCMAKE_CROSSCOMPILING_EMULATOR=wine -DCMAKE_BUILD_TYPE=Release && \
#ninja && \
#ninja install  | true && \
#cd .. && \
#rm -rf build-mingw64-glm && \
#rm -rf glm

#RUN cp -r glm/glm /usr/x86_64-w64-mingw32/sys-root/mingw/include/glm

#RUN rm -rf glm
#RUN rm -rf pcl
RUN rm -rf cgal
RUN rm -rf build-mingw64-cgal

COPY glm.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/


#COPY CMakeLists.txt pcl

#RUN git clone https://github.com/STEllAR-GROUP/hpx hpx --branch 1.3.0


#RUN cp hwloc/include/*.h /usr/x86_64-w64-mingw32/sys-root/mingw/include
#RUN cp -r hwloc/include/hwloc /usr/x86_64-w64-mingw32/sys-root/mingw/include
#RUN cp hwloc/hwloc/.libs/*.dll /usr/x86_64-w64-mingw32/sys-root/mingw/lib
#RUN cp hwloc/hwloc/.libs/*.dll.a /usr/x86_64-w64-mingw32/sys-root/mingw/lib

#COPY hpx/util/plugin/detail/dll_windows.hpp hpx/hpx/util/plugin/detail

#use binary pcl

COPY binary_pcl /usr/x86_64-w64-mingw32/sys-root/mingw

COPY low_level_io.h                 /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/io
COPY common_headers.h               /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/common
COPY common.h                       /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/common
COPY sac.h                          /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/sample_consensus
COPY hdl_grabber.h                  /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/io
COPY boundary.h                     /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/features
COPY moment_of_inertia_estimation.h /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/features
COPY auxiliary.h                    /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/recognition
COPY obj_rec_ransac.h               /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/recognition
COPY region_growing.h               /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/segmentation
COPY permutohedral.h                /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/ml
COPY file_io.h                      /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/io
COPY auto_io.h                      /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/io
COPY entropy_range_coder.h          /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/io
COPY eigen.h                        /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/common
COPY pcl_macros.h                   /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl
COPY bearing_angle_image.h          /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/common
COPY ndt_2d.hpp                     /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/registration/impl
COPY min_cut_segmentation.hpp       /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/segmentation/impl
COPY region_growing.hpp             /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/segmentation/impl
COPY spin_image.hpp                 /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/features/impl
COPY 3dsc.hpp                       /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/features/impl
COPY angles.hpp                     /usr/x86_64-w64-mingw32/sys-root/mingw/include/pcl-1.10/pcl/common/impl

# let's hope that we could get mingw to demangle msvc symbol correctly

#RUN mkdir build-mingw64-pcl && \
#cd build-mingw64-pcl && \
#mingw64-cmake ../pcl -GNinja -DCMAKE_CXX_VISIBILITY_PRESET=hidden -DCMAKE_C_VISIBILITY_PRESET=hidden -DPCL_SHARED_LIBS=TRUE -DWITH_LIBUSB=FALSE -DWITH_VTK=FALSE -DWITH_QT=FALSE -DCMAKE_CROSSCOMPILING=TRUE -DCMAKE_CROSSCOMPILING_EMULATOR=wine -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_TOOLS=FALSE && \
#ninja && \
#ninja install && \
#cd .. && \
#rm -rf build-mingw64-pcl

#COPY hpx/src/runtime/threads/topology.cpp hpx/src/runtime/threads

#COPY hpx/config.hpp hpx/hpx

COPY cross_file_mingw64.txt /opt/


COPY binary_openni2 /usr/x86_64-w64-mingw32/sys-root/mingw

RUN dnf remove -y meson && dnf install -y ninja-build && pip3 install meson

#RUN mkdir build-mingw64-hpx && \
#cd build-mingw64-hpx && \
#mingw64-cmake ../hpx -GNinja -DHPX_MINGW=TRUE -DHWLOC_ROOT=/usr/x86_64-w64-mingw32/sys-root/mingw/ -DHWLOC_LIBRARY=/usr/x86_64-w64-mingw32/sys-root/mingw/lib -DHWLOC_INCLUDE_DIR=/usr/x86_64-w64-mingw32/sys-root/mingw/include -DHPX_WITH_EXAMPLES=OFF -DHPX_WITH_TESTS=OFF -DHPX_WITH_TESTS_BENCHMARKS=OFF -DHPX_WITH_TESTS_REGRESSIONS=OFF -DHPX_WITH_TESTS_UNIT=OFF -DHPX_WITH_TESTS_EXTERNAL_BUILD=OFF -DHPX_WITH_TESTS_EXAMPLES=OFF -DHPX_WITH_COMPILE_ONLY_TESTS=OFF -DHPX_WITH_FAIL_COMPILE_TESTS=OFF -D_WIN32_WINNT=0x0A00 && \
#ninja && \
#ninja install && \
#cd .. && \
#rm -rf build-mingw64-hpx




