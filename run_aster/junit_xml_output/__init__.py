# coding=utf-8
# --------------------------------------------------------------------
# Copyright (c) 2013 Atlassian Corporation Pty Ltd
# Copyright HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

# Source: https://bitbucket.org/db_atlass/python-junit-xml-output-module

# The MIT License (MIT)

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import xml.etree.ElementTree as ET
import xml.dom.minidom

__version__ = "1.0.3"


class JunitXml(object):

    """ A class which is designed to create a junit test xml file.
        Note: currently this class is designed to return the junit xml file
        in a string format (through the dump method).
    """

    def __init__(self, testsuit_name, test_cases, total_tests=None,
                 total_failures=None, total_time=None):
        self.testsuit_name = testsuit_name
        self.test_cases = test_cases
        self.failing_test_cases = self._get_failing_test_cases()
        self.total_tests = total_tests
        self.total_failures = total_failures
        self.total_time = total_time
        if total_tests is None:
            self.total_tests = len(self.test_cases)
        if total_failures is None:
            self.total_failures = len(self.failing_test_cases)
        self.root = ET.Element("testsuite",
                               {"name": str(self.testsuit_name),
                                "failures": str(self.total_failures),
                                "tests": str(self.total_tests)
                               })
        self.build_junit_xml()
        if self.total_time:
            self.root.set("time", "{:.2f}".format(self.total_time))

    def _get_failing_test_cases(self):
        return set([case for case in self.test_cases if
                    case.is_failure()])

    def build_junit_xml(self):
        """ create the xml tree from the given testsuite name and
            testcase
        """
        total = 0.
        for case in self.test_cases:
            test_case_element = ET.SubElement(self.root,
                                              "testcase",
                                              {"name": str(case.name),
                                               "time": str(case.time)})
            if case.test_type:
                elt = ET.Element(case.test_type)
                elt.text = case.contents
                if case.message:
                    elt.set("message", case.message)
                test_case_element.append(elt)
            total += float(case.time)
        self.total_time = self.total_time or total

    def dump(self, pretty=True):
        """ returns a string representation of the junit xml tree. """
        out = ET.tostring(self.root)
        if pretty:
            dom = xml.dom.minidom.parseString(out)
            out = dom.toprettyxml()
        return out


class TestCase(object):

    """ A junit test case representation class.
            The JunitXml accepts a set of these and uses them to create
        the junit test xml tree
    """

    def __init__(self, name, contents, message=None, test_type="", time=0):
        self.name = name
        self.contents = contents
        self.message = message
        if test_type not in ("", "skipped", "failure"):
            test_type = "failure"
        self.test_type = test_type
        self.time = time

    def is_failure(self):
        """ returns True if this test case is a 'failure' type """
        return self.test_type == "failure"
