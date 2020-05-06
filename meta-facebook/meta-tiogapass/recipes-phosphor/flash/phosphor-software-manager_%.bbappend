FILESEXTRAPATHS_prepend_tiogapass := "${THISDIR}/${PN}:"
SRC_URI += "file://bios-update.sh"

EXTRA_OEMESON += "-Dhost-bios-upgrade=enabled"
RDEPENDS_${PN} += "bash"

do_install_append_tiogapass() {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/bios-update.sh ${D}/${sbindir}/
}
