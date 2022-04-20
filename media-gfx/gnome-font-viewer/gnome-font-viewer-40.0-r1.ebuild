# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit gnome.org meson xdg

DESCRIPTION="Font viewer utility for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-font-viewer"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=x11-libs/gtk+-3.24.1:3
	>=gui-libs/libhandy-1.0.0:1=
	>=media-libs/harfbuzz-0.9.9:=
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	gnome-base/gnome-desktop:3=
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# From Gentoo:
	# 	https://bugs.gentoo.org/831639
	"${FILESDIR}"/${PN}-40.0-fix-meson-0.61-build.patch
)
