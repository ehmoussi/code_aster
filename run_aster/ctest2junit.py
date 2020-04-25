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
        ``LastTest.log`` is also parsed to get the elapsed time of testcases
        in failure.
        """
        cost = osp.join(self.base, "Testing", "Temporary", "CTestCostData.txt")
        lastlog = osp.join(self.base, "Testing", "Temporary", "LastTest.log")
        if not osp.isfile(cost):
            return

        re_test_time = re.compile(
            r"^(?P<ctname>ASTER_[0-9\.]+_(?P<name>\S+)) +"
            r"(?P<ok>[0-9]+) +"
            r"(?P<time>[0-9\.,]+)", re.M)
        re_test = re.compile(r"^(\S+)", re.M)
        with open(cost, "r") as fcost:
            text = fcost.read()
        passed, failed = text.split("---")
        iternames = re_test_time.finditer(passed)
        failures = re_test.findall(failed)

        with open(lastlog, "r") as flog:
            log = flog.read()
        re_elaps = re.compile(
            r".(?P<ctname>ASTER_[0-9\.]+_(?P<name>\S+)). +"
            r"time elapsed: +(?P<time>[0-9]+:[0-9]+:[0-9]+)")
        timedict = {}
        for mat in re_elaps.finditer(log):
            hours, mins, secs = mat.group("time").split(':')
            secs = int(hours) * 3600 + int(mins) * 60 + int(secs)
            timedict[mat.group("name")] = secs

        self.junit_test = []
        for mat in iternames:
            ctname = mat.group("ctname")
            testname = mat.group("name")
            jstate = "failure" if ctname in failures else ""
            mess = osp.join(self.base, testname + ".mess")
            if osp.isfile(mess):
                with open(mess, "rb") as fmess:
                    output = fmess.read().decode(errors="replace")
                state = get_state(output)
                if "NOT_RUN" in state:
                    jstate = "skipped"
                details = []
                if jstate:
                    details.append(get_nook(output))
                    details.append(get_err_msg(output))
                content = "\n".join(details)
            else:
                output = ""
                state = f"not found: {mess}"
                content = ""
            time = float(mat.group("time").replace(",", "."))
            self.junit_test.append(
                JUNIT.TestCase(ctname, content, state, jstate,
                               time or timedict[testname]))

    def write_xml(self, filename):
        """Export the report in XML.

        Arguments:
            filename (str): Output XML file (relative to the base directory).
        """
        junit = JUNIT.JunitXml("code_aster " + CFG.get("version_tag", "?") +
                               "-" + CFG.get("version_sha1", "?"),
                               self.junit_test)
        with open(osp.join(self.base, filename), "w") as fobj:
            fobj.write(junit.dump())


RE_ERRMSG = re.compile(r"(\<[ESF]\>.*?)!\-\-\-", re.M | re.DOTALL)
RE_EXCEP = re.compile(r"(\<EXCEPTION\>.*?)!\-\-\-", re.M | re.DOTALL)
RE_SUPERV = re.compile("DEBUT RAPPORT(.*?)FIN RAPPORT", re.M | re.DOTALL)
RE_STATE = re.compile("DIAGNOSTIC JOB : (.*)", re.M)

def get_state(txt):
    """Extract the test state for a 'message' file content.

    Arguments:
        txt (str): '.mess' file content.

    Returns:
        str: Error messages.
    """
    state = RE_STATE.findall(txt)
    if not state:
        return "?"
    return state[-1]

def get_err_msg(txt):
    """Extract the error message for a 'message' file content.

    Arguments:
        txt (str): '.mess' file content.

    Returns:
        str: Error messages.
    """
    found = (RE_ERRMSG.findall(txt)
             or RE_EXCEP.findall(txt)
             or RE_SUPERV.findall(txt))
    msg = _clean_msg(found)
    return os.linesep.join(msg)

def get_nook(txt):
    """Extract NOOK values from a 'message' file content.

    Arguments:
        txt (str): '.mess' file content.

    Returns:
        str: Text of OK/NOOK values.
    """
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


if __name__ == "__main__":
    report = XUnitReport(".")
    report.read_ctest()
    junit = JUNIT.JunitXml("code_aster", report.junit_test)
    print(junit.dump())
