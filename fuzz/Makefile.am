AM_CFLAGS = $(WERROR_CFLAGS) $(WARN_CFLAGS) -Wno-unused-parameter -Wno-pedantic
AM_CPPFLAGS = -I$(top_srcdir)/lib/includes -I$(top_builddir)/lib/includes -I$(srcdir) \
 -DSRCDIR=\"$(abs_srcdir)\" -DTEST_RUN

LDADD = ../gl/libgnu.la ../lib/libgnutls.la \
 $(LIBOBJS) $(GETADDRINFO_LIB) $(HOSTENT_LIB) $(INET_NTOP_LIB)\
 $(LIBSOCKET) $(LIB_CLOCK_GETTIME) $(LIB_NANOSLEEP) $(LIB_POLL) $(LIB_PTHREAD)\
 $(LIB_SELECT) $(LIBTHREAD) $(SERVENT_LIB) \
 $(LIBS)

FUZZERS = \
 gnutls_x509_verify_fuzzer$(EXEEXT) \
 gnutls_base64_decoder_fuzzer$(EXEEXT) \
 gnutls_base64_encoder_fuzzer$(EXEEXT) \
 gnutls_client_fuzzer$(EXEEXT) \
 gnutls_client_rawpk_fuzzer$(EXEEXT) \
 gnutls_dn_parser_fuzzer$(EXEEXT) \
 gnutls_idna_parser_fuzzer$(EXEEXT) \
 gnutls_ocsp_req_parser_fuzzer$(EXEEXT) \
 gnutls_ocsp_resp_parser_fuzzer$(EXEEXT) \
 gnutls_pkcs12_key_parser_fuzzer$(EXEEXT) \
 gnutls_pkcs7_parser_fuzzer$(EXEEXT) \
 gnutls_pkcs8_key_parser_fuzzer$(EXEEXT) \
 gnutls_private_key_parser_fuzzer$(EXEEXT) \
 gnutls_psk_client_fuzzer$(EXEEXT) \
 gnutls_psk_server_fuzzer$(EXEEXT) \
 gnutls_reverse_idna_parser_fuzzer$(EXEEXT) \
 gnutls_server_fuzzer$(EXEEXT) \
 gnutls_server_rawpk_fuzzer$(EXEEXT) \
 gnutls_set_trust_file_fuzzer$(EXEEXT) \
 gnutls_x509_crl_parser_fuzzer$(EXEEXT) \
 gnutls_x509_crq_parser_fuzzer$(EXEEXT) \
 gnutls_x509_parser_fuzzer$(EXEEXT) \
 gnutls_ext_raw_parse_fuzzer$(EXEEXT) \
 gnutls_handshake_client_fuzzer$(EXEEXT) \
 gnutls_handshake_server_fuzzer$(EXEEXT)

if ENABLE_SRP
FUZZERS += \
 gnutls_srp_client_fuzzer$(EXEEXT) \
 gnutls_srp_server_fuzzer$(EXEEXT)
endif

check_PROGRAMS = $(FUZZERS)

COMMON_SOURCES = main.c fuzzer.h
gnutls_x509_verify_fuzzer_SOURCES = gnutls_x509_verify_fuzzer.c $(COMMON_SOURCES)
gnutls_base64_decoder_fuzzer_SOURCES = gnutls_base64_decoder_fuzzer.c $(COMMON_SOURCES)
gnutls_base64_encoder_fuzzer_SOURCES = gnutls_base64_encoder_fuzzer.c $(COMMON_SOURCES)
gnutls_client_fuzzer_SOURCES = gnutls_client_fuzzer.c $(COMMON_SOURCES) mem.h certs.h
gnutls_client_rawpk_fuzzer_SOURCES = gnutls_client_rawpk_fuzzer.c $(COMMON_SOURCES) mem.h certs.h
gnutls_handshake_client_fuzzer_SOURCES = gnutls_handshake_client_fuzzer.c $(COMMON_SOURCES) handshake.h
gnutls_dn_parser_fuzzer_SOURCES = gnutls_dn_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_idna_parser_fuzzer_SOURCES = gnutls_idna_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_ocsp_req_parser_fuzzer_SOURCES = gnutls_ocsp_req_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_ocsp_resp_parser_fuzzer_SOURCES = gnutls_ocsp_resp_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_pkcs12_key_parser_fuzzer_SOURCES = gnutls_pkcs12_key_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_pkcs7_parser_fuzzer_SOURCES = gnutls_pkcs7_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_pkcs8_key_parser_fuzzer_SOURCES = gnutls_pkcs8_key_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_private_key_parser_fuzzer_SOURCES = gnutls_private_key_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_psk_client_fuzzer_SOURCES = gnutls_psk_client_fuzzer.c $(COMMON_SOURCES) mem.h psk.h
gnutls_psk_server_fuzzer_SOURCES = gnutls_psk_server_fuzzer.c $(COMMON_SOURCES) mem.h psk.h
gnutls_reverse_idna_parser_fuzzer_SOURCES = gnutls_reverse_idna_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_server_fuzzer_SOURCES = gnutls_server_fuzzer.c $(COMMON_SOURCES) mem.h certs.h
gnutls_server_rawpk_fuzzer_SOURCES = gnutls_server_rawpk_fuzzer.c $(COMMON_SOURCES) mem.h certs.h
gnutls_handshake_server_fuzzer_SOURCES = gnutls_handshake_server_fuzzer.c $(COMMON_SOURCES) handshake.h certs.h
gnutls_srp_client_fuzzer_SOURCES = gnutls_srp_client_fuzzer.c $(COMMON_SOURCES) mem.h srp.h
gnutls_srp_server_fuzzer_SOURCES = gnutls_srp_server_fuzzer.c $(COMMON_SOURCES) mem.h srp.h
gnutls_set_trust_file_fuzzer_SOURCES = gnutls_set_trust_file_fuzzer.c $(COMMON_SOURCES)
gnutls_x509_crl_parser_fuzzer_SOURCES = gnutls_x509_crq_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_x509_crq_parser_fuzzer_SOURCES = gnutls_x509_crq_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_x509_parser_fuzzer_SOURCES = gnutls_x509_parser_fuzzer.c $(COMMON_SOURCES)
gnutls_ext_raw_parse_fuzzer_SOURCES = gnutls_ext_raw_parse_fuzzer.c $(COMMON_SOURCES)

gnutls_set_trust_file_fuzzer_LDADD = $(LDADD) $(LIBDL)


#EXTRA_DIST = $(wildcard *.options) $(wildcard *.dict) \
# $(wildcard *.in) $(wildcard *.repro)

# We don't include the fuzz corpora into the tarball.
# Testing the corpora during dev cycles and in the CI is enough.
dist-hook:
	find . -name '*.options' -exec cp -v '{}' $(distdir) ';'
	find . -name '*.dict' -exec cp -v '{}' $(distdir) ';'
#	find . -name '*.in' -exec cp -vr '{}' $(distdir) ';'
	find . -name '*.repro' -exec cp -vr '{}' $(distdir) ';'

TESTS = $(FUZZERS)

clean-local:
	rm -rf *.gc?? *.log lcov

oss-fuzz:
	if test "$$OUT" != ""; then \
	for ccfile in *_fuzzer.c; do \
	fuzzer=$$(basename $$ccfile .c); \
	XLIBS="-lhogweed -lnettle -ltasn1 -lgmp -lidn2 -lunistring"; \
	$$CC $$CFLAGS -I$(top_srcdir)/lib/includes/ -I$(top_srcdir) \
	-c "$${fuzzer}.c" -o "$${fuzzer}.o" ; \
	$$CXX $$CXXFLAGS "$${fuzzer}.o" -o "$${fuzzer}" \
	$$LDFLAGS ../lib/.libs/libgnutls.a $${LIB_FUZZING_ENGINE} \
	-Wl,-z,muldefs \
	-Wl,-Bstatic \
	$${XLIBS} \
	-Wl,-Bdynamic || exit $?; \
	done; \
	fi

.PHONY: oss-fuzz

CFLAGS ?=
LDFLAGS ?=
LCOV_INFO = coverage.info

coverage-prepare: clean
	rm -rf $(LCOV_INFO) ../*/*.gc?? ../*/.libs/*.gc?? lcov/
	lcov --zerocounters --directory ../lib/
	$(MAKE) -C .. clean
	$(MAKE) -C ../gl
	$(MAKE) -C ../lib CFLAGS="$(CFLAGS) --coverage" LDFLAGS="$(LDFLAGS) --coverage"

coverage:
	lcov --capture --initial --directory ../lib/ --output-file $(LCOV_INFO)
	$(MAKE) check CFLAGS="$(CFLAGS) --coverage" LDFLAGS="$(LDFLAGS) --coverage"
	lcov --capture --directory ../lib/ --output-file $(LCOV_INFO)
	lcov --remove $(LCOV_INFO) '/usr/include/*' '*/gl/*' -o $(LCOV_INFO)
	genhtml --prefix . --ignore-errors source $(LCOV_INFO) --legend --title "gnutls-fuzz" --output-directory=lcov
	@echo
	@echo "You can now view the coverage report with 'xdg-open lcov/index.html'"
