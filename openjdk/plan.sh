pkg_origin=core
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_name=openjdk8
pkg_version=8.172.0
pkg_tag_name=jdk8u172-b11
pkg_dirname=jdk8u
pkg_source=http://hg.openjdk.java.net/jdk8u/jdk8u
# pkg_shasum=87b6e4bf4c089feb7d15cdd80914069a50f7364f037c6ef8641ad084d862f7ac
# pkg_filename=${pkg_upstream_tag_sha}.tar.gz
pkg_license=('TODO')
pkg_description=('TODO')
pkg_upstream_url=http://openjdk.java.net/projects/jdk8u/
pkg_deps=(
  core/glibc/2.22 # JDK 8 will not build on > 2.24
  core/gcc-libs/5.2.0 # pinning for glibc
  core/xlib
  core/xproto # for X.h and shape.h
  core/libxext # ...which requires shapeconst.h, provided by:
  core/xextproto # ...which requires Xrender.h, provided by:
  core/libxrender # ... which requires render.h, provided by:
  core/renderproto
  core/libice
  core/libxtst # for XTest.h, which requires XInput.h, provided by:
  core/libxi # which require XI.h, provided by:
  core/inputproto
  core/libxt # for Intrinsic.h
  scotthain/cups
  core/zlib # required for freetype
  core/libpng # required for freetype
  core/freetype
  core/alsa-lib
)
pkg_build_deps=(
  core/mercurial
  core/gcc/5.2.0
  core/make
  core/bash
  core/diffutils
  core/pkg-config
  core/cpio
  core/which
  core/zip
  core/jdk8
)
pkg_bin_dirs=(bin jre/bin)
pkg_lib_dirs=(lib lib/amd64)
pkg_include_dirs=(include)

do_download() {
  # Download OpenJDK source from Mercurial repo per instructions here:
  # http://openjdk.java.net/guide/repositories.html#clone
  REPO_PATH="$HAB_CACHE_SRC_PATH/$pkg_dirname"
  rm -rf "$REPO_PATH"
  mkdir -p "$REPO_PATH"
  hg clone -r $pkg_tag_name http://hg.openjdk.java.net/jdk8u/jdk8u "$REPO_PATH"
  pushd "$REPO_PATH" || return 1
    $(pkg_path_for bash)/bin/bash get_source.sh
  popd || return 1
}

do_unpack() {
  return 0
}

do_clean() {
  return 0
}

do_verify() {
  return 0
}

do_build() {
  $(pkg_path_for bash)/bin/bash \
    ./configure \
    --prefix=${pkg_prefix} \
    --with-boot-jdk=$(pkg_path_for jdk8)

  $(pkg_path_for make)/bin/make
}

do_check() {
  $(pkg_path_for make)/bin/make check
}