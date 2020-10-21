FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append_tiogapass += "file://SetTimeBmc.sh"
SRC_URI_append_yosemitev2 += "file://SetTimeBmc.sh"
SYSTEMD_SERVICE_${PN} += "bmc-set-time.service"
RDEPENDS_${PN} += "bash"

do_install_append(){

    install -d ${D}$/lib/systemd/system
    install -m 0644 ${WORKDIR}/bmc-set-time.service  ${D}$/lib/systemd/system
    install -d ${D}/usr/sbin
    install -m 0777 ${WORKDIR}/SetTimeBmc.sh ${D}/usr/sbin

}
