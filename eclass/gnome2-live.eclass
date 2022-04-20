# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnome2-live.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @AUTHOR:
# Nirbheek Chauhan <nirbheek@gentoo.org>
# @BLURB: Live ebuild phases for GNOME packages
# @DESCRIPTION:
# Exports additional functions used by live ebuilds written for GNOME packages
# Always to be imported *AFTER* gnome2.eclass

inherit autotools eutils gnome2 gnome2-utils libtool git-r3 xdg

EXPORTED_FUNCTIONS=" "
case "${EAPI:-0}" in
	6|7)
		EXPORT_FUNCTIONS src_prepare pkg_postinst
		;;
	*)
		die "EAPI=${EAPI} is not supported" ;;
esac

# DEPEND on
# app-text/gnome-doc-utils for gnome-doc-*
# dev-util/gtk-doc for gtkdocize
# dev-util/intltool for intltoolize
# gnome-base/gnome-common for GNOME_COMMON_INIT
DEPEND="${DEPEND}
	app-text/gnome-doc-utils
	app-text/yelp-tools
	dev-util/gtk-doc
	dev-util/intltool
	gnome-base/gnome-common
	sys-devel/gettext"

# Extra options passed to elibtoolize
ELTCONF=${ELTCONF:-}

# @ECLASS_VARIABLE: GNOME_LIVE_MODULE
# @DESCRIPTION:
# Default git module name is assumed to be the same as the gnome.org module name
# used on ftp.gnome.org. We have GNOME_ORG_MODULE because we inherit gnome.org
: ${GNOME_LIVE_MODULE:="${GNOME_ORG_MODULE}"}

# @ECLASS_VARIABLE: EGIT_REPO_URI
# @DESCRIPTION:
# git URI for the project, uses GNOME_LIVE_MODULE by default
: "${EGIT_REPO_URI:="https://gitlab.gnome.org/GNOME/${GNOME_LIVE_MODULE}.git"}"

# @ECLASS_VARIABLE: PATCHES
# @DESCRIPTION:
# Whitespace-separated list of patches to apply after cloning
: ${PATCHES:=""}

# Unset SRC_URI auto-set by gnome2.eclass
SRC_URI=""

# @FUNCTION: gnome2-live_get_var
# @DESCRIPTION:
# Get macro variable values from configure.ac, etc
gnome2-live_get_var() {
	local var f
	var="$1"
	f="$2"
	echo $(sed -ne "s/${var}(\(.*\))/\1/p" "${f}" | tr -d '[]')
}

# @FUNCTION: gnome2-live_src_unpack
# @DESCRIPTION:
# Calls git-2_src_unpack, and unpacks ${A} if required.
# Also calls gnome2-live_src_prepare for older EAPI.
gnome2-live_src_unpack() {
	die "gnome2-live_src_unpack is banned starting with EAPI=6"
}

# @FUNCTION: gnome2-live_src_prepare
# @DESCRIPTION:
# Lots of magic to workaround autogen.sh quirks in various packages
# Creates blank ChangeLog and necessary macro dirs. Runs various autotools
# programs if required, and finally runs eautoreconf.
gnome2-live_src_prepare() {
	for i in ${PATCHES}; do
		eapply "${i}"
	done

	eapply_user

	# If ChangeLog doesn't exist, maybe it's autogenerated
	# Avoid a `dodoc` failure by adding an empty ChangeLog
	if ! test -e ChangeLog; then
		echo > ChangeLog
	fi

	### Keep this in-sync with gnome2.eclass!

	xdg_src_prepare

	# Prevent assorted access violations and test failures
	gnome2_environment_reset

	# Prevent scrollkeeper access violations
	# We stop to run it from EAPI=6 as scrollkeeper helpers from
	# rarian are not running anything and, then, access violations
	# shouldn't occur.
	has ${EAPI:-0} 4 5 && gnome2_omf_fix

	# Run eautoreconf
	# https://bugzilla.gnome.org/show_bug.cgi?id=591584
	eautoreconf
}

# @FUNCTION: gnome2_src_unpack
# @DESCRIPTION:
# Defined so that it replaces gnome2_src_unpack in ebuilds that call it
gnome2_src_unpack() {
	gnome2-live_src_unpack
}

# @FUNCTION: gnome2_src_prepare
# @DESCRIPTION:
# Defined so that it replaces gnome2_src_prepare in ebuilds that call it
gnome2_src_prepare() {
	gnome2-live_src_prepare
}

# @FUNCTION: gnome2-live_pkg_postinst
# @DESCRIPTION:
# Must be run manually for ebuilds that have a custom pkg_postinst
gnome2-live_pkg_postinst() {
	gnome2_pkg_postinst

	ewarn "This is a live ebuild, upstream trunks will mostly be UNstable"
	ewarn "Do NOT report bugs about this package to Gentoo"
	ewarn "Report upstream bugs (with patches if possible) instead."
}