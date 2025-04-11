# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python{3_10,3_11,3_12,3_13} )
VALA_MIN_API_VERSION="0.52"

inherit gnome.org gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Play the classic two-player boardgame of chess"
HOMEPAGE="https://wiki.gnome.org/Apps/Chess https://gitlab.gnome.org/GNOME/gnome-chess"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE="+engines"

RDEPEND="
	>=dev-libs/glib-2.44:2
	gui-libs/gtk:4
	>=gnome-base/librsvg-2.46.0:2
	engines? (
		games-board/crafty
		games-board/gnuchess
		games-board/sjeng
		games-board/stockfish
	)
"
DEPEND="${RDEPEND}
	gnome-base/librsvg:2[vala]
"
BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/itstool
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-chess/-/commit/bb7c28e41c5ba12781eb169e5379ca62d171b3d9
	"${FILESDIR}"/${PN}-41.0-help-fix-image-installation.patch
)

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
