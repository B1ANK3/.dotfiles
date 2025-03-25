# Lingo program from lindo systems
# From AUR: https://aur.archlinux.org/packages/lingo
# https://wiki.archlinux.org/title/PKGBUILD
# https://nixos.org/guides/nix-pills/08-generic-builders.html
/*
prepare() {
	cd "$srcdir"
	chmod a+x "${pkgname}-${pkgver}.run"
	./"${pkgname}-${pkgver}.run"  --mode unattended --prefix ${srcdir}/usr/share/${pkgname}
	mkdir -p ${srcdir}/usr/lib/${pkgname}
	mv ${srcdir}/usr/share/${pkgname}/bin/linux64/* ${srcdir}/usr/lib/${pkgname}

	mv ${srcdir}/usr/lib/${pkgname}/lingo${pkgver%.*}.bin  ${srcdir}/usr/lib/${pkgname}/lingo.bin

	sed -i "s|VER|${pkgver%.*}|g" runlingo.sh
	install -Dm755 runlingo.sh ${srcdir}/usr/bin/runlingo
	install -Dm755 runlingo.sh ${srcdir}/usr/bin/lingo
	sed -i 's/runlingo.bin/lingo.bin/g' ${srcdir}/usr/bin/lingo

	sed -i "s|__VER__|${pkgver}|g" lingo.desktop
	install -Dm644 lingo.desktop  -t ${srcdir}/usr/share/applications


	cd ${srcdir}/usr/share/${pkgname}
	rm -rf uninstall.dat uninstall *.desktop runlingo lingo${pkgver%.*} *.log

	# icon
	cd ${srcdir}/usr/share/${pkgname}/images
	# convert lingo128.ico to png
	convert "lingo128.ico" -thumbnail 128x128 -alpha on -background none -flatten "lingo.png"
	install -Dm644 lingo.png -t ${srcdir}/usr/share/icons/hicolor/128x128/apps
	rm lingo.png


	cd ${srcdir}/usr/lib/${pkgname}/
	rm -rf libQt5* platforms/libqxcb.so # qt5-base
	# ln -sf /usr/lib/qt/plugins/platforms/libqxcb.so platforms/libqxcb.so
	rm -rf libgcc_s* libgfortran* libquadmath* #gcc-libs
	rm -rf libtbb* #tbb

}


package() {
	cd "$srcdir"
	mv usr "${pkgdir}"

	cd "${pkgdir}"/usr/share/${pkgname}
	mkdir -p ${pkgdir}/usr/share/doc
	mv doc ${pkgdir}/usr/share/doc/${pkgname}
	ln -s /usr/share/doc/${pkgname} ${pkgdir}/usr/share/${pkgname}/doc

	chmod 0755 -R ${pkgdir}/usr/lib/${pkgname}

	cd ${pkgdir}/usr/share/${pkgname}
	find . -type f  -exec chmod 644 {} \;
	find . -type d  -exec chmod 755 {} \;
	chmod a+w LINGO.CNF
	chmod a+w -R license
	rm -rf bin programming_samples/c/runlingo/runlingo.bin
	cd ${pkgdir}/usr/share/doc/${pkgname}
	find . -type f  -exec chmod 644 {} \;

}
*/
# pkgrel=1
{
  stdenv,
  lib,
  pkgs,
  fetchurl,
  ...
}:
stdenv.mkDerivation rec {
  # pkgname=lingo
  name = "lingo";
  # pkgver=20.0
  version = "20.0";
  # url='https://www.lindo.com'
  url = "https://www.lindo.com";

  # source=("${pkgname}-${pkgver}.run::${url}/downloads/Lingo-${pkgver}-linux-x64-installer.run"
  # 'runlingo.sh'
  # 'lingo.desktop'
  # )
  # sha256sums=('e6ed9b8541e0ee3f13c66739e72e8b5343f796e8204179603bafbc4fedc04fbd'
  #          'eaeefbec47a5ab44176dd1088bf83bb3724d369fe12d033e7c9d62b00aaa1653'
  #            '8c12e4675d2507d6d91e73b16c10f7b313778cb91e29be14a83f8d73fb1d1b63')
  # DLAGENT is used to circumvent packages that need verification
  # DLAGENTS=("https::/usr/bin/curl -A 'Mozilla' -fLC - --retry 3 --retry-delay 3 -o %o %u")
  src = fetchurl {
    url = "${url}/downloads/Lingo-${version}-linux-x64-installer.run";
    curlOpts = "-A 'Mozilla' -fLC - --retry 3 --retry-delay 3";
    sha256 = "sha256-5u2bhUHg7j8Txmc55y6LU0P3luggQXlgO6+8T+3AT70=";
  };

  # makedepends=('shared-mime-info' 'desktop-file-utils' 'imagemagick' 'patchelf')
  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  # depends=('gcc-libs' 'qt5-base' 'tbb')
  buildInputs = with pkgs; [
    libgcc
    libsForQt5.qt5.qtbase
    tbb
  ];

  meta = with lib; {
    # pkgdesc='Comprehensive modeling language and solvers for linear, non-linear, and integer programming.'
    description = "Comprehensive modeling language and solvers for linear, non-linear, and integer programming.";
    homepage = "https://www.lindo.com";
    # license=('unknown')
    maintainers = with maintainers; [];
    # arch=('x86_64')
  };
}
