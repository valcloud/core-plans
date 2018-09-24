pkg_name=cups
pkg_version=2.2.8
pkg_origin=core
pkg_license=('TODO')
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
# pkg_dirname=cups-2.2
pkg_source=https://github.com/apple/${pkg_name}/releases/download/v${pkg_version}/${pkg_name}-${pkg_version}-source.tar.gz
pkg_filename=${pkg_name}-${pkg_version}.tar.gz
pkg_shasum=3968fc1d26fc48727508db1c1380e36c6694ab90177fd6920aec5f6cc73af9e4
pkg_deps=(
  core/glibc
  core/gcc-libs
)
pkg_build_deps=(
  core/gcc
  core/make
)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)

do_build() {
    ./configure \
    --prefix=${pkg_prefix} \
    --enable-static \
    --enable-shared
    make
}

do_check() {
  make check
}