## Process this file with automake to produce Makefile.in
# Copyright (C) 2010, 2012 Free Software Foundation, Inc.
#
# This file is part of GnuTLS.
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.

AM_CFLAGS = $(WARN_CFLAGS) $(WERROR_CFLAGS)
AM_CPPFLAGS = -I$(top_srcdir)/lib/includes		\
	-I$(top_builddir)/lib/includes \
	-I$(top_srcdir)/tests/ \
	-I$(top_srcdir)/lib \
	-I$(top_builddir)/gl \
	-I$(top_srcdir)/gl

if ENABLE_MINITASN1
AM_CPPFLAGS += -I$(top_builddir)/lib/minitasn1
endif

AM_LDFLAGS = -no-install
LDADD = ../libutils.la \
	../../gl/libgnu.la \
	$(top_builddir)/lib/libgnutls.la $(LIBSOCKET)

cipher_test_CPPFLAGS = $(AM_CPPFLAGS)

ctests = gendh


dist_check_SCRIPTS = test-ciphers.sh test-hash-large.sh test-ciphers-common.sh \
	test-ciphers-api.sh
check_PROGRAMS = $(ctests) cipher-test cipher-api-test hash-large crypto
TESTS = $(ctests) test-ciphers.sh test-hash-large.sh crypto test-ciphers-api.sh

if HAVE_LIBCRYPTO
cipher_openssl_compat_LDADD = $(LDADD) $(LIBCRYPTO)

dist_check_SCRIPTS += test-ciphers-openssl.sh
check_PROGRAMS += cipher-openssl-compat
TESTS += test-ciphers-openssl.sh
endif

EXTRA_DIST = README gnutls-asan.supp

TESTS_ENVIRONMENT = EXEEXT=$(EXEEXT) \
	LC_ALL="C"						\
	LSAN_OPTIONS=suppressions=$(srcdir)/gnutls-asan.supp	\
	GNUTLS_TEST_SUITE_RUN=1					\
	OPENSSL_ia32cap=0x00000000				\
	GNUTLS_SYSTEM_PRIORITY_FILE=$(abs_top_srcdir)/tests/system.prio	\
	top_builddir="$(top_builddir)"				\
	abs_top_builddir="$(abs_top_builddir)"			\
	srcdir="$(srcdir)"

if WINDOWS
TESTS_ENVIRONMENT += WINDOWS=1
endif
