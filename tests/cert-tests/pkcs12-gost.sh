#!/bin/sh

# Copyright (C) 2018 Dmitry Eremin-Solenikov
# Copyright (C) 2016 Red Hat, Inc.
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

# This test cannot run under windows because it passes UTF8 data on command
# line. This seems not to work under windows.

: ${srcdir=.}
: ${CERTTOOL=../../src/certtool${EXEEXT}}

if ! test -x "${CERTTOOL}"; then
	exit 77
fi

if test "${GNUTLS_FORCE_FIPS_MODE}" = 1;then
	echo "Cannot run in FIPS140-2 mode"
	exit 77
fi

if ! test -z "${VALGRIND}"; then
	VALGRIND="${LIBTOOL:-libtool} --mode=execute ${VALGRIND} --error-exitcode=1"
fi

: ${DIFF=diff}
DEBUG=""

TMPFILE=pkcs12-gost.$$.tmp
TMPFILE_PEM=pkcs12-gost.$$.tmp.pem

echo "Testing decoding of known keys"
echo "=============================="

ret=0
for p12 in "gost01.p12 Пароль%20для%20PFX" "gost12.p12 Пароль%20для%20PFX" "gost12-2.p12 Пароль%20для%20PFX" ; do
	set -- ${p12}
	file="$1"
	passwd=$(echo $2|sed 's/%20/ /g')

	if test "x$DEBUG" != "x"; then
		${VALGRIND} "${CERTTOOL}" -d 99 --p12-info --inder --password "${passwd}" \
			--infile "${srcdir}/data/${file}"
	else
		${VALGRIND} "${CERTTOOL}" --p12-info --inder --password "${passwd}" \
			--infile "${srcdir}/data/${file}" >/dev/null
	fi
	rc=$?
	if test ${rc} != 0; then
		echo "PKCS12 FATAL ${p12}"
		exit 1
	fi
done


echo ""
echo "Testing encoding/decoding"
echo "========================="

${VALGRIND} "${CERTTOOL}" --pkcs-cipher=gost28147-tc26z --hash streebog-256 --to-p12 --password "Пароль для PFX" --p12-name "my-key" --load-certificate "${srcdir}/../certs/cert-ecc256.pem" --load-privkey "${srcdir}/../certs/ecc256.pem" --load-ca-certificate "${srcdir}/../certs/ca-cert-ecc.pem" --outder --outfile $TMPFILE >/dev/null
rc=$?
if test ${rc} != 0; then
	echo "PKCS12 FATAL encoding"
	exit 1
fi

${VALGRIND} "${CERTTOOL}" --p12-info --inder --password "Пароль для PFX" --infile $TMPFILE >${TMPFILE_PEM} 2>/dev/null
rc=$?
if test ${rc} != 0; then
	echo "PKCS12 FATAL decrypting/decoding"
	exit 1
fi

${VALGRIND} "${CERTTOOL}" --pkcs-cipher=gost28147-tc26z --hash streebog-512 --to-p12 --password "Пароль для PFX" --p12-name "my-key" --load-certificate "${srcdir}/../certs/cert-ecc256.pem" --load-privkey "${srcdir}/../certs/ecc256.pem" --load-ca-certificate "${srcdir}/../certs/ca-cert-ecc.pem" --outder --outfile $TMPFILE >/dev/null
rc=$?
if test ${rc} != 0; then
	echo "PKCS12 FATAL encoding"
	exit 1
fi

${VALGRIND} "${CERTTOOL}" --p12-info --inder --password "Пароль для PFX" --infile $TMPFILE >${TMPFILE_PEM} 2>/dev/null
rc=$?
if test ${rc} != 0; then
	echo "PKCS12 FATAL decrypting/decoding"
	exit 1
fi

rm -f "$TMPFILE" "$TMPFILE_PEM"

exit 0
