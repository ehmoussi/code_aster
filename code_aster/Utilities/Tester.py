# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

import os.path as osp
import unittest
from unittest.util import safe_repr
from functools import wraps

RESULT_FILE = "fort.8"

# keep possible usage out of code_aster
try:
    from Deprecated import writeInResu
except ImportError:
    def writeInResu(text):
        print(text)

# TODO assertRaises methods
# TODO add more test methods
# TODO use the logger object
# TODO tell the RunManager to increase the exit status in case of failure
#      (throug the logger) ?


def addSuccess(method):
    """Decorator to wrap TestCase methods by calling writeResult"""
    @wraps(method)
    def wrapper(inst, *args, **kwds):
        """wrapper"""
        try:
            ret = method(inst, *args, **kwds)
        except AssertionError, exc:
            ret = None
            inst.writeResult( False, method.__name__, kwds.get('msg'), str(exc) )
        else:
            inst.writeResult( True, method.__name__, kwds.get('msg') )
        return ret
    return wrapper


class Test( unittest.TestCase ):
    """Similar to a unittest.TestCase
    Does not fail but print result OK/NOOK in the .resu file"""

    def __init__(self):
        """Initialization"""
        self._passed = 0
        self._failure = 0
        super(Test, self).__init__('runTest')

    def runTest(self):
        """does nothing"""
        pass

    def printSummary(self):
        """Print a summary of the tests"""
        print("-" * 70)
        count = self._passed + self._failure
        print("Ran {0} tests, {1} passed, {2} in failure".format(
            count, self._passed, self._failure))
        if self._failure:
            print("\nFAILED\n")
        else:
            print("\nOK\n")

    def writeResult(self, ok, funcTest, msg, exc=None):
        """Write a message in the result file"""
        # TODO ask ExecutionParameter for the working directory
        wrkdir = "."
        exc = exc or ""
        msg = msg or exc
        if ok:
            self._passed += 1
            fmt = " OK  {0:>16} passed"
        else:
            self._failure += 1
            fmt = "NOOK {0:>16} failed: {1}"
        writeInResu(fmt.format(funcTest, msg))

    @addSuccess
    def assertTrue(self, expr, msg=None):
        """Check that the expression is true."""
        super(Test, self).assertTrue(expr, msg)

    @addSuccess
    def assertEqual(self, first, second, msg=None):
         super(Test, self).assertEqual(first, second, msg)


if __name__ == '__main__':
    test = Test()
    test.assertTrue( type(1) is int )
    test.assertEqual( 1 , 1 )
    test.assertEqual( 1 , 0 )
