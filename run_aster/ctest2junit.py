# coding=utf-8
# --------------------------------------------------------------------
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

"""
:py:mod:`ctest2junit` --- Convert a CTest execution report to JUnit
-------------------------------------------------------------------

This module converts a report from CTest to JUnit format.

This creates a XML file that can be presented by *Continous Integration*
tools.
"""

import os
import os.path as osp
import re

from . import junit_xml_output as JUNIT
from .config import CFG


class XUnitReport:
    """Represents a report to be exported at the xUnit format.

    Arguments:
        resudir (str): Directory containing the result files.
    """

    def __init__(self, resudir):
        self.base = resudir
        self.junit_test = []

    def read_ctest(self):
        """Read the CTest report.

        It reads the list of testcases that passed and that failed from the
        ``CTestCostData.txt`` file and extracts detailed informations (error
        messages, OK/NOOK results) from ``.mess`` files.
        """
        cost = osp.join(osp.join(self.base, "Testing", "Temporary"),
                                 "CTestCostData.txt")
        if not osp.isfile(cost):
            return

        re_test = re.compile("^(.+?) ", re.M)
        with open(cost, "r") as fcost:
            text = fcost.read()
        passed, failed = text.split("---")
        names = re_test.findall(passed)
        failures = re_test.findall(failed)

        re_name = re.compile(r"ASTER_[0-9\.]+_(.*)")
        self.junit_test = []
        for name in names:
            testname = name
            mat = re_name.search(name)
            if mat:
                testname = mat.group(1)
            jstate = "failure" if name in failures else ""
            output = osp.join(self.base, testname + ".mess")
            details = [get_state(output)]
            if jstate and osp.isfile(output):
                details.append(get_nook(output))
            else:
                details.append(get_err_msg(output))
            content = "\n".join(details)
            self.junit_test.append(JUNIT.TestCase(name, content, jstate))

    def write_xml(self, filename):
        """Export the report in XML.

        Arguments:
            filename (str): Output XML file (relative to the base directory).
        """
        junit = JUNIT.JunitXml("code_aster " + CFG.get("version_tag", ""),
                               self.junit_test)
        with open(osp.join(self.base, filename), "w") as fobj:
            fobj.write(junit.dump())


RE_ERRMSG = re.compile(r"(\<[ESF]\>.*?)!\-\-\-", re.M | re.DOTALL)
RE_EXCEP = re.compile(r"(\<EXCEPTION\>.*?)!\-\-\-", re.M | re.DOTALL)
RE_SUPERV = re.compile("DEBUT RAPPORT(.*?)FIN RAPPORT", re.M | re.DOTALL)
RE_STATE = re.compile("DIAGNOSTIC JOB : (.*)", re.M | re.DOTALL)

def get_state(fname):
    """Extract the test state for a 'message' file.

    Arguments:
        fname (str): '.mess' file.

    Returns:
        str: Error messages.
    """
    if not osp.isfile(fname):
        return f"not found: {fname}"
    with open(fname, "rb") as fobj:
        txt = fobj.read().decode(errors="replace")
    state = RE_STATE.findall(txt)
    if not state:
        return "?"
    return state[-1]

def get_err_msg(fname):
    """Extract the error message for a 'message' file.

    Arguments:
        fname (str): '.mess' file.

    Returns:
        str: Error messages.
    """
    if not osp.isfile(fname):
        return f"not found: {fname}"
    msg = []
    with open(fname, "rb") as fobj:
        txt = fobj.read().decode(errors="replace")
    found = (RE_ERRMSG.findall(txt)
             or RE_EXCEP.findall(txt)
             or RE_SUPERV.findall(txt))
    msg.extend(_clean_msg(found))
    return os.linesep.join(msg)

def get_nook(fname):
    """Extract NOOK values from a 'message' file.

    Arguments:
        fname (str): '.mess' file.

    Returns:
        str: Text of OK/NOOK values.
    """
    if not osp.isfile(fname):
        return "not found: {fname}"
    with open(fname, "rb") as fobj:
        txt = fobj.read().decode(errors="replace")
    reg_resu = re.compile("^( *(?:REFERENCE|OK|NOOK) .*$)", re.M)
    lines = reg_resu.findall(txt)
    return os.linesep.join(lines)

def _clean_msg(lmsg):
    """Some cleanups in the found messages."""
    out = []
    redeb = re.compile(r"^\s*!\s*", re.M)
    refin = re.compile(r"\s*!\s*$", re.M)
    reefs = re.compile("Cette erreur sera suivie .*", re.M | re.DOTALL)
    reefa = re.compile("Cette erreur est fatale.*", re.M | re.DOTALL)
    for msg in lmsg:
        msg = redeb.sub("", msg)
        msg = refin.sub("", msg)
        msg = reefs.sub("", msg)
        msg = reefa.sub("", msg)
        msg = [line for line in msg.splitlines() if line.strip() != ""]
        out.append(os.linesep.join(msg))
    return out
