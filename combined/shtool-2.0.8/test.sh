#!/bin/sh
##
##  test.sh -- GNU shtool test suite driver
##  Copyright (c) 1999-2008 Ralf S. Engelschall <rse@engelschall.com>
##
##  This file is part of shtool and free software; you can redistribute
##  it and/or modify it under the terms of the GNU General Public
##  License as published by the Free Software Foundation; either version
##  2 of the License, or (at your option) any later version.
##
##  This file is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
##  General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
##  USA, or contact Ralf S. Engelschall <rse@engelschall.com>.
##

shtool=../shtool
testdb=../test.db

#   move to a subdirectory
rm -rf test.sd >/dev/null 2>&1
mkdir test.sd || exit 1
cd test.sd || exit 1

#   make sure the tool and database exists
test -f $shtool || exit 1
test -f $testdb || exit 1

#   iterate over all tool tests
TOOLS=`grep '^@begin' $testdb | sed -e 's/^@begin{//' -e 's/}.*$//'`
failed=0
passed=0
ran=0
for tool in $TOOLS; do
    rm -rf ./* >/dev/null 2>&1
    echo "${tool}..............." | awk '{ printf("%s", substr($0, 0, 15)); }'
    sed -e "/^@begin{$tool}/,/^@end{$tool}/p" -e '1,$d' $testdb |\
    sed -e '/^@begin/d' -e '/^@end/d' \
        -e 's/\([^\\]\)[ 	]*$/\1 || exit 1/g' \
        -e "s;shtool;$shtool;g" >run.sh
    echo "exit 0" >>run.sh
    sh -x run.sh >run.log 2>&1
    if [ $? -ne 0 ]; then
        #   generate report
        echo "FAILED"
        echo "+---Test------------------------------"
        cat run.sh | sed -e 's/^/| /g'
        echo "+---Trace-----------------------------"
        cat run.log | sed -e 's/^/| /g'
        failed=`expr $failed + 1`
        echo "+-------------------------------------"
    else
        passed=`expr $passed + 1`
        echo "ok"
    fi
    ran=`expr $ran + 1`
done

#   cleanup
cd ..
rm -rf test.sd >/dev/null 2>&1

#   result
if [ $failed -gt 0 ]; then
    echo "FAILED: passed: $passed/$ran, failed: $failed/$ran"
else
    echo "OK: passed: $passed/$ran"
fi
exit 0

