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
: ${DIFF=diff -b -B}

if ! test -x "${CERTTOOL}"; then
	exit 77
fi

if ! test -z "${VALGRIND}"; then
	VALGRIND="${LIBTOOL:-libtool} --mode=execute ${VALGRIND}"
fi

TMPFILE1=ca-no-pathlen-$$.tmp
TMPFILE2=no-ca-or-pathlen-$$.tmp
${VALGRIND} "${CERTTOOL}" --certificate-info --infile "${srcdir}/data/ca-no-pathlen.pem" \
	|grep -v "Algorithm Security Level"|grep -v ^warning > $TMPFILE1
rc=$?

if test "${rc}" != "0"; then
	echo "info 1 failed"
	exit ${rc}
fi

${VALGRIND} "${CERTTOOL}" --certificate-info --infile "${srcdir}/data/no-ca-or-pathlen.pem" \
	|grep -v "Algorithm Security Level" > $TMPFILE2
rc=$?

if test "${rc}" != "0"; then
	echo "info 2 failed"
	exit ${rc}
fi

${DIFF} "${srcdir}/data/ca-no-pathlen.pem" $TMPFILE1
rc1=$?
${DIFF} "${srcdir}/data/no-ca-or-pathlen.pem" $TMPFILE2
rc2=$?


# We're done.
if test "${rc1}" != "0"; then
	exit ${rc1}
fi

rm -f $TMPFILE1 $TMPFILE2

exit ${rc2}
