SUMMARY = "Node Manager Proxy"
DESCRIPTION = "The Node Manager Proxy provides a simple interface for communicating \
with Management Engine via IPMB"

FILESEXTRAPATHS_prepend_tiogapass := "${THISDIR}/${PN}:"

SRC_URI = "git://git@github.com/Intel-BMC/node-manager;protocol=ssh"
SRCREV = "de212d839bb515939bd089c66072e4fcf33b8653"
SRC_URI += "file://v3-0001-Add-ME-health-status-property.patch"
SRC_URI += "file://0001-Temp-fix-for-sdbusplus-build-issue.patch"

PV = "0.1+git${SRCPV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SYSTEMD_SERVICE_${PN} = "node-manager-proxy.service"

DEPENDS = "sdbusplus \
           phosphor-logging \
           boost"

S = "${WORKDIR}/git/"
inherit cmake systemd
