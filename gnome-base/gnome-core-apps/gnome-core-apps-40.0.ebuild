# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Metapackage for GNOME core applications"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="*"

IUSE="+bluetooth +cdr cups"

RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-menus-3.36.0
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups(+)?]

	>=app-crypt/gcr-3.40.0
	>=gnome-base/nautilus-${PV}
	>=gnome-base/gnome-keyring-3.36.0
	>=gnome-extra/evolution-data-server-3.40.0

	>=app-crypt/seahorse-3.37.0
	>=app-editors/gedit-${PV}
	>=app-text/evince-${PV}
	>=gnome-extra/gnome-contacts-$(ver_cut 1-2)
	>=media-gfx/eog-${PV}
	>=media-video/totem-3.34.0
	>=x11-terms/gnome-terminal-3.40.0

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-${PV}

	>=x11-themes/adwaita-icon-theme-$(ver_cut 1-2)
	>=x11-themes/gnome-themes-extra-3.28

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.34.0 )
	cdr? ( >=app-cdr/brasero-3.12.2 )
"
DEPEND=""

S="${WORKDIR}"
