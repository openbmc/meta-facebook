FILESEXTRAPATHS_prepend_tiogapass := "${THISDIR}/${PN}:"
SRC_URI += "file://bios-update.sh"

PACKAGECONFIG_append = " flash_bios"

do_install_append_tiogapass() {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/bios-update.sh ${D}/${sbindir}/
}
