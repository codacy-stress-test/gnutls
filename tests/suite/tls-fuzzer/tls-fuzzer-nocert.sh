#!/bin/bash

# Copyright (C) 2016-2017 Red Hat, Inc.
#
# This file is part of GnuTLS.
#
# GnuTLS is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 3 of the License, or (at
# your option) any later version.
#
# GnuTLS is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GnuTLS.  If not, see <https://www.gnu.org/licenses/>.

: ${srcdir=.}

if test "${GNUTLS_FORCE_FIPS_MODE}" = 1;then
	echo "Cannot run in FIPS140-2 mode"
	exit 77
fi

tls_fuzzer_prepare() {
VERSIONS="-VERS-ALL:+VERS-TLS1.3:+VERS-TLS1.2:+VERS-TLS1.1:+VERS-TLS1.0:+VERS-SSL3.0"
PRIORITY="NORMAL:%VERIFY_ALLOW_SIGN_WITH_SHA1:+ARCFOUR-128:+3DES-CBC:+DHE-DSS:+SIGN-DSA-SHA256:+SIGN-DSA-SHA1:-CURVE-SECP192R1:${VERSIONS}:+SHA256:+SHA384:+AES-128-CCM:+AES-256-CCM:+AES-128-CCM-8:+AES-256-CCM-8"
${CLI} --list --priority "${PRIORITY}" >/dev/null 2>&1
if test $? != 0;then
	PRIORITY="NORMAL:%VERIFY_ALLOW_SIGN_WITH_SHA1:+ARCFOUR-128:+3DES-CBC:+DHE-DSS:+SIGN-DSA-SHA256:+SIGN-DSA-SHA1:${VERSIONS}:+SHA256:+SHA384:+AES-128-CCM:+AES-256-CCM:+AES-128-CCM-8:+AES-256-CCM-8"
fi

sed -e "s|@SERVER@|$SERV|g" -e "s/@PORT@/$PORT/g" -e "s/@PRIORITY@/$PRIORITY/g" ../gnutls-nocert.json >${TMPFILE}
}

. "${srcdir}/tls-fuzzer/tls-fuzzer-common.sh"
