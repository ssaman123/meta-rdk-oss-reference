# kbd ptest bbappend
# Based on upstream OE-Core implementation by Qiu Tingting
# Adapted for kbd 2.4.0 (only installs directories that exist in this version)

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://run-ptest"

inherit ptest

RDEPENDS:${PN}-ptest += "bash"

PACKAGES = "${PN}"
do_compile_ptest() {
    # update DATADIR in Makefile
    sed -i 's,-DDATADIR=.*,-DDATADIR=\\\"${PTEST_PATH}/tests\\\" \\,g' ${B}/tests/libkeymap/Makefile
    sed -i 's,-DDATADIR=.*,-DDATADIR=\\\"${PTEST_PATH}/tests\\\" \\,g' ${B}/tests/helpers/Makefile
    sed -i 's,-DDATADIR=.*,-DDATADIR=\\\"${PTEST_PATH}/tests\\\" \\,g' ${B}/tests/libkbdfile/Makefile

    # recompile tests
    oe_runmake -C ${B}/tests/ clean
    oe_runmake -C ${B}/tests/
}

do_install_ptest() {
    # install test binaries from build directory
    install -d ${D}${PTEST_PATH}/tests/
    install --mode=755 ${B}/tests/testsuite ${D}${PTEST_PATH}/tests/
    
    install -d ${D}${PTEST_PATH}/tests/libkeymap/
    find ${B}/tests/libkeymap/ -type f -not -name "*.o" -not -name "Makefile" \
        -exec install --mode=755 {} ${D}${PTEST_PATH}/tests/libkeymap/ \;
    
    install -d ${D}${PTEST_PATH}/tests/helpers/
    find ${B}/tests/helpers/ -type f -not -name "*.o" -not -name "Makefile" \
        -exec install --mode=755 {} ${D}${PTEST_PATH}/tests/helpers/ \;
    
    install -d ${D}${PTEST_PATH}/tests/libkbdfile/
    find ${B}/tests/libkbdfile/ -type f -not -name "*.o" -not -name "Makefile" \
        -exec install --mode=755 {} ${D}${PTEST_PATH}/tests/libkbdfile/ \;
    
    install -d ${D}${PTEST_PATH}/src/
    install --mode=755 ${B}/src/loadkeys ${D}${PTEST_PATH}/src/

    # install keymap data from src/data directory
    install -d ${D}${PTEST_PATH}/data/keymaps/i386/qwerty/
    install ${S}/data/keymaps/i386/qwerty/defkeymap.map ${D}${PTEST_PATH}/data/keymaps/i386/qwerty/

    # install test data files from src/tests/data directory
    # Note: kbd 2.4.0 has different structure than 2.5.1
    install -d ${D}${PTEST_PATH}/tests/data/
    
    # libkeymap test data
    install -d ${D}${PTEST_PATH}/tests/data/libkeymap/
    install ${S}/tests/data/libkeymap/* ${D}${PTEST_PATH}/tests/data/libkeymap/
    
    # alt-is-meta test data
    install -d ${D}${PTEST_PATH}/tests/data/alt-is-meta/
    install ${S}/tests/data/alt-is-meta/* ${D}${PTEST_PATH}/tests/data/alt-is-meta/
    
    # bkeymap-2.0.4 test data
    install -d ${D}${PTEST_PATH}/tests/data/bkeymap-2.0.4/
    install ${S}/tests/data/bkeymap-2.0.4/* ${D}${PTEST_PATH}/tests/data/bkeymap-2.0.4/
    
    # dumpkeys test data
    install -d ${D}${PTEST_PATH}/tests/data/dumpkeys-mktable/
    install ${S}/tests/data/dumpkeys-mktable/* ${D}${PTEST_PATH}/tests/data/dumpkeys-mktable/
    
    install -d ${D}${PTEST_PATH}/tests/data/dumpkeys-fulltable/
    install ${S}/tests/data/dumpkeys-fulltable/* ${D}${PTEST_PATH}/tests/data/dumpkeys-fulltable/
    
    # findfile test data (complex structure)
    install -d ${D}${PTEST_PATH}/tests/data/findfile/test_1/consolefonts/
    install ${S}/tests/data/findfile/test_1/consolefonts/* ${D}${PTEST_PATH}/tests/data/findfile/test_1/consolefonts/
    
    install -d ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/
    install ${S}/tests/data/findfile/test_0/keymaps/test0.map ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/
    
    install -d ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/include/
    install ${S}/tests/data/findfile/test_0/keymaps/include/* ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/include/
    
    install -d ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/i386/include/
    install ${S}/tests/data/findfile/test_0/keymaps/i386/include/* ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/i386/include/
    
    install -d ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/i386/qwerty/
    install ${S}/tests/data/findfile/test_0/keymaps/i386/qwerty/* ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/i386/qwerty/
    
    install -d ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/i386/qwertz/
    install ${S}/tests/data/findfile/test_0/keymaps/i386/qwertz/* ${D}${PTEST_PATH}/tests/data/findfile/test_0/keymaps/i386/qwertz/

    # Note: kbd 2.4.0 does NOT have tests/data/keymaps/ at top level
    # (that was added in 2.5.x), so we skip those install commands

    # update PTEST_PATH in run-ptest
    sed -i "s#@PTEST_PATH@#${PTEST_PATH}#g" ${D}${PTEST_PATH}/run-ptest
}
PACKAGE_DEBUG_SPLIT_STYLE:wrynose = "debug-without-src"
INSANE_SKIP:${PN} += "installed-vs-shipped"
