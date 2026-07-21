ALTERNATIVE:${PN}-misc:remove = " corelist cpan enc2xs encguess h2ph h2xs instmodsh json_pp libnetcfg \
                     piconv pl2pm pod2html pod2man pod2text pod2usage podchecker podselect \
                     prove ptar ptardiff ptargrep shasum splain xsubpp zipdetails"

FILES:${PN}:remove = " ${bindir}/perl ${bindir}/pcorelist ${bindir}/pcpan ${bindir}/enc2xs ${bindir}/encguess ${bindir}/h2ph ${bindir}/h2xs ${bindir}/instmodsh ${bindir}/json_pp ${bindir}/libnetcfg \
                     ${bindir}/piconv ${bindir}/pl2pm ${bindir}/pod2html ${bindir}/pod2man ${bindir}/pod2text ${bindir}/pod2usage ${bindir}/podchecker ${bindir}/podselect \
                     ${bindir}/prove ${bindir}/ptar ${bindir}/ptardiff ${bindir}/ptargrep ${bindir}/shasum ${bindir}/splain ${bindir}/xsubpp ${bindir}/zipdetails \
                     ${libdir}/perl5/site_perl ${libdir}/perl5/config.sh ${libdir}/perl5/${PV}/strict.pm ${libdir}/perl5/${PV}/warnings.pm \
                     ${libdir}/perl5/${PV}/warnings ${libdir}/perl5/${PV}/vars.pm ${libdir}/perl5/site_perl ${libdir}/perl5/${PV}/ExtUtils/MANIFEST.SKIP \
                     ${libdir}/perl5/${PV}/ExtUtils/xsubpp ${libdir}/perl5/${PV}/ExtUtils/typemap"

PACKAGE_PREPROCESS_FUNCS:remove = " perl_package_preprocess"
PACKAGE_PREPROCESS_FUNCS:append = " perl_package_preprocess_reduced"
perl_package_preprocess_reduced () {
        # Fix up installed configuration
        sed -i -e "s,${D},,g" \
               -e "s,${DEBUG_PREFIX_MAP},,g" \
               -e "s,--sysroot=${STAGING_DIR_HOST},,g" \
               -e "s,-isystem${STAGING_INCDIR} ,,g" \
               -e "s,${STAGING_LIBDIR},${libdir},g" \
               -e "s,${STAGING_BINDIR},${bindir},g" \
               -e "s,${STAGING_INCDIR},${includedir},g" \
               -e "s,${STAGING_BINDIR_NATIVE}/perl-native/,${bindir}/,g" \
               -e "s,${STAGING_BINDIR_NATIVE}/,,g" \
               -e "s,${STAGING_BINDIR_TOOLCHAIN}/${TARGET_PREFIX},${bindir},g" \
               -e 's:${RECIPE_SYSROOT}::g' \
            ${PKGD}${libdir}/perl5/${PV}/${TARGET_ARCH}-linux/Config.pod \
            ${PKGD}${libdir}/perl5/${PV}/${TARGET_ARCH}-linux/Config_git.pl \
            ${PKGD}${libdir}/perl5/${PV}/${TARGET_ARCH}-linux/Config_heavy.pl
}

EXTRA_OECONF:append = " -Ui_ndbm -Ui_dbm"

do_configure:prepend() {
    # Forcefully prevent the config system from enabling ndbm
    sed -i 's/i_ndbm=define/i_ndbm=undef/g' ${S}/hints/linux.sh || true
    sed -i 's/i_dbm=define/i_dbm=undef/g' ${S}/hints/linux.sh || true
}
CFLAGS:append = " -DNDBM_H_USES_PROTOTYPES"
