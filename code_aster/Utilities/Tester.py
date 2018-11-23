# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

"""
:py:mod:`Tester` --- Checking code_aster execution of testcases
***************************************************************

"""

import os.path as osp
import re
import unittest
import unittest.case as case
from functools import partial, wraps
from unittest.util import safe_repr

import libaster

# TODO use the logger object
# TODO tell the RunManager to increase the exit status in case of failure
#      (through the logger) ?


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


class AssertRaisesContext(case._AssertRaisesContext):
    """Wrap Context of TestCase object"""

    def __init__(self, expected, test_case, expected_regexp=None):
        self.writeResult = test_case.writeResult
        # these two lines already exist in __exit__ in python >= 2.7.9
        if isinstance(expected_regexp, basestring):
            expected_regexp = re.compile(expected_regexp)
        super(AssertRaisesContext, self).__init__(expected, test_case, expected_regexp)

    def __exit__(self, exc_type, exc_value, tb):
        comment = ""
        try:
            ret = super(AssertRaisesContext, self).__exit__(exc_type, exc_value, tb)
            if not ret:
                try:
                    exc_name = exc_type.__name__
                except AttributeError:
                    exc_name = str(exc_type)
                raise AssertionError("unexpected exception raised: "
                                     "{0}".format(exc_name))
        except AssertionError, exc:
            ret = False
            comment = str(exc)
        self.writeResult( ret, self.expected.__name__, comment )
        # never fail
        return True


class TestCase( unittest.TestCase ):
    """Similar to a unittest.TestCase
    Does not fail but print result OK/NOOK in the .resu file"""

    def __init__(self, methodName='runTest', silent=False):
        """Initialization"""
        self._silent = silent
        self._passed = 0
        self._failure = 0
        super(TestCase, self).__init__('runTest')

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
        if self._silent:
            return
        wrkdir = "."
        exc = exc or ""
        msg = msg or exc
        if ok:
            self._passed += 1
            fmt = " OK  {0:>16} passed"
        else:
            self._failure += 1
            fmt = "NOOK {0:>16} failed: {1}"
        libaster.write(fmt.format(funcTest, msg))

    # just use a derivated context class
    def assertRaises(self, excClass, callableObj=None, *args, **kwargs):
        """Fail unless an exception of class excClass is raised"""
        context = AssertRaisesContext(excClass, self)
        if callableObj is None:
            return context
        with context:
            callableObj(*args, **kwargs)

    def assertRaisesRegexp(self, expected_exception, expected_regexp,
                           callable_obj=None, *args, **kwargs):
        """Asserts that the message in a raised exception matches a regexp."""
        context = AssertRaisesContext(expected_exception, self, expected_regexp)
        if callable_obj is None:
            return context
        with context:
            callable_obj(*args, **kwargs)


def _add_assert_methods(cls):
    for meth in  ['assertAlmostEqual',
                  'assertDictContainsSubset',
                  'assertDictEqual',
                  'assertEqual',
                  'assertFalse',
                  'assertGreater',
                  'assertGreaterEqual',
                  'assertIn',
                  'assertIs',
                  'assertIsInstance',
                  'assertIsNone',
                  'assertIsNot',
                  'assertIsNotNone',
                  'assertItemsEqual',
                  'assertLess',
                  'assertLessEqual',
                  'assertMultiLineEqual',
                  'assertNotAlmostEqual',
                  'assertNotEqual',
                  'assertNotIn',
                  'assertNotIsInstance',
                  'assertNotRegexpMatches',
                  'assertRegexpMatches',
                  'assertSequenceEqual',
                  'assertSetEqual',
                  'assertTrue',
                  'assertTupleEqual']:
        setattr(cls, meth, addSuccess(getattr(unittest.TestCase, meth)))

_add_assert_methods(TestCase)
del _add_assert_methods
