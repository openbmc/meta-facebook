FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://powerOnSlot.service"
SRC_URI_append = " file://powerOnSlot.sh"

RDEPENDS_${PN} += "bash"

do_install_append(){

    install -d ${D}/lib/systemd/system
    install -m 0644 ${WORKDIR}/powerOnSlot.service ${D}/lib/systemd/system

    install -d ${D}/usr/sbin
    install -m 0777 ${WORKDIR}/powerOnSlot.sh ${D}/usr/sbin
}

FILES_${PN} += "/lib/systemd/system/powerOnSlot.service"
