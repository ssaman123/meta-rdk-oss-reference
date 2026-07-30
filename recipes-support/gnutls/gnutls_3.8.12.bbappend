PACKAGECONFIG:remove:broadband:wrynose = "libidn"

PACKAGES := "${PN}"
PACKAGES:remove = "\
    ${PN}-src \
    ${PN}-dbg \
    ${PN}-doc \
    ${PN}-locale \
"

PACKAGE_DEBUG_SPLIT_STYLE = "debug-without-src"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

do_install:append() {
    rm -rf ${D}${libdir}/.debug
    rm -rf ${D}${bindir}/.debug

    rm -rf ${D}${mandir}
    rm -rf ${D}${infodir}
    rm -rf ${D}${datadir}/locale
}

FILES:${PN} += "\
    ${includedir} \
    ${libdir}/pkgconfig \
    ${libdir}/*.so.* \
    ${bindir} \
    ${datadir} \
"

INSANE_SKIP:${PN} += "installed-vs-shipped"
INSANE_SKIP:${PN} += "dev-deps"
