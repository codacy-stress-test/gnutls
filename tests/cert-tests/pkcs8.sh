#!/bin/sh

# Copyright (C) 2014 Nikos Mavrogiannopoulos
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
: ${CERTTOOL=../../src/certtool${EXEEXT}}
: ${GREP=grep}

TMPFILE=tmp-key-ca.$$.p8

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

# check keys with password
${VALGRIND} "${CERTTOOL}" --to-p8 --load-privkey  "${srcdir}/data/key-ca.pem" --password "1234" \
	--outfile $TMPFILE 2>/dev/null

${GREP} "BEGIN ENCRYPTED PRIVATE KEY" $TMPFILE  >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in converting key to PKCS #8 with password"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" -k --pkcs8 --infile "${srcdir}/data/key-ca.pem" --password "1234" >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading PKCS #8 key with password"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" -k --pkcs8 --infile "${srcdir}/data/key-ca-1234.p8" --password "1234" >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading saved PKCS #8 key with password"
	exit ${rc}
fi

#keys encrypted with empty password
${VALGRIND} "${CERTTOOL}" --to-p8 --load-privkey  "${srcdir}/data/key-ca.pem" --password "" \
		--outfile $TMPFILE 2>/dev/null

${GREP} "BEGIN PRIVATE KEY" $TMPFILE  >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in converting key to PKCS #8 with empty password"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" -k --pkcs8 --infile "${srcdir}/data/key-ca.pem" --password "" >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading PKCS #8 key with empty password"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" -k --pkcs8 --infile "${srcdir}/data/key-ca-empty.p8" --password "" >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading saved PKCS #8 key with empty password"
	exit ${rc}
fi

#keys encrypted with null password
${VALGRIND} "${CERTTOOL}" --to-p8 --load-privkey  "${srcdir}/data/key-ca.pem" --null-password \
	--outfile $TMPFILE 2>/dev/null

${GREP} "BEGIN ENCRYPTED PRIVATE KEY" $TMPFILE >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in converting key to PKCS #8 with null password"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" -k --pkcs8 --infile "${srcdir}/data/key-ca.pem" --null-password >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading PKCS #8 key with null password"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" -k --pkcs8 --infile "${srcdir}/data/key-ca-null.p8" --null-password >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading saved PKCS #8 key with null password"
	exit ${rc}
fi

# Tests for PKCS #8 ECC keys

${VALGRIND} "${CERTTOOL}" -k --infile "${srcdir}/data/key-ecc.pem" >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading saved ECC key"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" -k --pkcs8 --infile "${srcdir}/data/key-ecc.p8" >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading saved PKCS #8 ECC key"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" -k --pkcs8 --infile "${srcdir}/data/openssl-key-ecc.p8" >/dev/null 2>&1
rc=$?
# We're done.
if test "${rc}" != "0"; then
	echo "Error in reading saved openssl PKCS #8 ECC key"
	exit ${rc}
fi

rm -f $TMPFILE

exit 0
