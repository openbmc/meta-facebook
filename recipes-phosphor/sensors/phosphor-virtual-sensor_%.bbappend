FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://virtual_sensor_config.json"

do_install_append() {

    install -d ${D}/usr/share/phosphor-virtual-sensor

    install -m 0644 -D ${WORKDIR}/virtual_sensor_config.json \
                   ${D}/usr/share/phosphor-virtual-sensor
}
