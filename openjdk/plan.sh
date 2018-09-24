pkg_origin=core
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_name=openjdk8
pkg_version=8.172.0
pkg_upstream_tag_sha=4d038b84d113
pkg_source=http://hg.openjdk.java.net/jdk8u/jdk8u/archive/4d038b84d113.tar.gz
pkg_shasum=87b6e4bf4c089feb7d15cdd80914069a50f7364f037c6ef8641ad084d862f7ac
pkg_filename=${pkg_upstream_tag_sha}.tar.gz
pkg_license=('TODO')
pkg_description=('TODO')
pkg_upstream_url=http://openjdk.java.net/projects/jdk8u/
pkg_deps=(
  core/glibc
  core/gcc-libs
)
pkg_build_deps=(
  core/gcc
  core/make
  core/bash
  core/diffutils
  core/pkg-config
  core/cpio
  core/which
  core/zip
  core/jdk8
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
pkg_bin_dirs=(bin jre/bin)
pkg_lib_dirs=(lib lib/amd64)
pkg_include_dirs=(include)
pkg_dirname=jdk8u-${pkg_upstream_tag_sha}

do_build() {
  $(pkg_path_for bash)/bin/bash \
    ./configure \
    --prefix=${pkg_prefix} \
    --with-boot-jdk=$(pkg_path_for jdk8) \
    # --with-extra-cflags="$CFLAGS" \
    # --with-extra-cxxflags="$CXXFLAGS" \
    # --with-extra-ldflags="$LDDFLAGS" \
    # --with-freetype-lib="$(pkg_path_for freetype)/lib" 
  $(pkg_path_for make)/bin/make
}

do_check() {
  $(pkg_path_for make)/bin/make check
}


# do_setup_environment() {
#  set_runtime_env JAVA_HOME "$pkg_prefix"
# }

# ## Refer to habitat/components/plan-build/bin/hab-plan-build.sh for help

# # Customomized download_file() to work around the Oracle EULA Cookie-wall
# #  See: http://stackoverflow.com/questions/10268583/downloading-java-jdk-on-linux-via-wget-is-shown-license-page-instead
# download_file() {
#   local url="$1"
#   local dst="$2"
#   local sha="$3"

#   build_line "By including the JDK you accept the terms of the Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX, which can be found at http://www.oracle.com/technetwork/java/javase/terms/license/index.html"

#   pushd "$HAB_CACHE_SRC_PATH" > /dev/null
#   if [[ -f $dst && -n "$sha" ]]; then
#     build_line "Found previous file '$dst', attempting to re-use"
#     if verify_file "$dst" "$sha"; then
#       build_line "Using cached and verified '$dst'"
#       return 0
#     else
#       build_line "Clearing previous '$dst' file and re-attempting download"
#       rm -fv "$dst"
#     fi
#   fi

#   build_line "Downloading '$url' to '$dst'"
#   $_wget_cmd --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  "$url" -O "$dst"
#   build_line "Downloaded '$dst'";
#   popd > /dev/null
# }

# do_unpack() {
#   local unpack_file="$HAB_CACHE_SRC_PATH/$pkg_filename"
#   mkdir "$source_dir"
#   pushd "$source_dir" >/dev/null
#   tar xz --strip-components=1 -f "$unpack_file"

#   popd > /dev/null
#   return 0
# }

# do_build() {
#   return 0
# }

# do_install() {
#   cd "$source_dir" || exit
#   cp -r ./* "$pkg_prefix"

#   build_line "Setting interpreter for '${pkg_prefix}/bin/java' '$(pkg_path_for glibc)/lib/ld-linux-x86-64.so.2'"
#   build_line "Setting rpath for '${pkg_prefix}/bin/java' to '$LD_RUN_PATH'"

#   export LD_RUN_PATH=$LD_RUN_PATH:$pkg_prefix/lib/amd64/jli:$pkg_prefix/lib/amd64:$pkg_prefix/jre/lib/amd64/jli:$pkg_prefix/jre/lib/amd64:$pkg_prefix/jre/lib/amd64/server

#   find "$pkg_prefix"/bin "$pkg_prefix"/jre/bin -type f -executable \
#     -exec sh -c 'file -i "$1" | grep -q "x-executable; charset=binary"' _ {} \; \
#     -exec patchelf --interpreter "$(pkg_path_for glibc)/lib/ld-linux-x86-64.so.2" --set-rpath "$LD_RUN_PATH" {} \;

#   find "$pkg_prefix"/lib/amd64/*.so "$pkg_prefix"/jre/lib/amd64 -type f \
#     -exec patchelf --set-rpath "${LD_RUN_PATH}" {} \;
# }

# do_strip() {
#   return 0
# }
