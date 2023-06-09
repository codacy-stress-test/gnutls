#!/bin/sh

# Copyright (C) 2006-2008, 2010, 2012 Free Software Foundation, Inc.
#
# Author: Simon Josefsson
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

set -e

: ${srcdir=.}
: ${CERTTOOL=../../src/certtool${EXEEXT}}
TMPFILE=aki-$$.tmp
: ${DIFF=diff -b -B}

if ! test -x "${CERTTOOL}"; then
	exit 77
fi

if ! test -z "${VALGRIND}"; then
	VALGRIND="${LIBTOOL:-libtool} --mode=execute ${VALGRIND}"
fi

${VALGRIND} "${CERTTOOL}" --certificate-info --infile "${srcdir}/data/aki-cert.pem" \
	|grep -v "Algorithm Security Level"|grep -v ^warning > $TMPFILE
rc=$?

if test "${rc}" != "0"; then
	echo "info failed"
	exit ${rc}
fi

${DIFF} "${srcdir}/data/aki-cert.pem" $TMPFILE
rc=$?

# We're done.
if test "${rc}" != "0"; then
	exit ${rc}
fi

rm -f $TMPFILE

exit 0
