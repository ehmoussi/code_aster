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
:py:mod:`status` --- Extract the state of a code_aster execution
----------------------------------------------------------------

The execution state is computed from the exit code of the execution
(null if the execution ends normally or !=0 otherwise) and the content of
the output of the execution (from `.mess` file).

For testcases, the execution may end normally but with a state not *Ok*
if there is no TEST_RESU or if it is NOOK.
"""

import argparse
import re
import sys


class Status:
    """Object that represents the status of an execution.

    Attributes:
        state (StateOptions): State of the execution.
        diag (str): State of the execution as string (diagnostic).
        exicode (int): Exit code.
        times (list[float]): List of 4 values: cpu, sys, tot, elapsed time.
    """
    def __init__(self, state=0, exitcode=-1):
        self._state = state
        self._exitcode = exitcode
        self._times = [0.] * 4

    @property
    def state(self):
        """StateOptions: Attribute that holds the 'state' property."""
        return self._state

    @state.setter
    def state(self, value):
        self._state = value

    @property
    def diag(self):
        """str: Attribute that holds the 'diag' property."""
        return StateOptions.name(self._state)

    @property
    def exitcode(self):
        """int: Attribute that holds the 'exitcode' property."""
        return self._exitcode

    @exitcode.setter
    def exitcode(self, iret):
        self._exitcode = iret

    @property
    def times(self):
        """list[float]: Attribute that holds the 'times' property."""
        return self._times

    @times.setter
    def times(self, values):
        assert len(values) == 4, values
        self._times = values

    def is_completed(self):
        """Tell if the calculation was completed (the result databases should
        be available.

        Returns:
            bool: *True* if the calculation was completed, *False* otherwise.
        """
        return bool(self.state & StateOptions.Completed)

    def update(self, other):
        """Update the status with a new one (from a following execution).
        It keeps the effective state, the worst exit code and the sum of
        elapsed times.

        Arguments:
            other (Status): Status of a following execution.
        """
        self.state = StateOptions.effective(self.state | other.state)
        self.exitcode = max(self.exitcode, other.exitcode)
        self.times = [i + j for i, j in zip(self.times, other.times)]


class StateOptions:
    """
    Enumerator for result state.

    Attributes:
        Warn: Execution emitted a warning.
        Nook: Invalid testcase execution (incorrect value).
        NoTest: Invalid testcase execution (no value checked).
        Ok: Execution was finished successfully.

        CpuLimit: Execution ended with cpu time error.
        Convergence: Execution ended with no convergence error.
        Memory: Execution ended with a memory error.
        Except: Execution ended with an exception.

        Syntax: Execution ended with a syntax error.
        Fatal: Execution ended with a fatal error.
        Abort: Execution ended abnormally.

        Completed: Execution run up to the end, the results files should
            be available.
        Error: Execution failed, results files may be missing or corrupted.
    """
    # null == unknown, no information
    Warn = 0x001
    Nook = 0x002
    NoTest = 0x004
    CpuLimit = 0x008
    Convergence = 0x010
    Memory = 0x020
    Except = 0x040
    Syntax = 0x080
    Fatal = 0x100
    Abort = 0x200
    Ok = 0x400

    Error = (CpuLimit | Convergence | Memory | Except
             | Syntax | Fatal | Abort)
    Completed = Ok | Warn | Nook | NoTest

    @staticmethod
    def effective(state):
        """Return the effective and consistent state.

        Returns:
            StateOptions: The effective state.
        """
        error = state & (StateOptions.Error ^ StateOptions.Abort)
        if error:
            return error
        if state & StateOptions.Abort:
            return StateOptions.Abort

        if state & StateOptions.NoTest:
            return StateOptions.NoTest | (state & StateOptions.Warn)
        if state & StateOptions.Nook:
            return StateOptions.Nook | (state & StateOptions.Warn)
        if state & StateOptions.Warn:
            return StateOptions.Warn
        if state & StateOptions.Ok:
            return StateOptions.Ok

        return 0

    @staticmethod
    def name(state):
        """
        Convert result state to string representation.

        Arguments:
            state (int): Result state (*StateOptions*).

        Returns:
            str: String representation of state.
        """
        if state & StateOptions.Abort:
            return "<F>_ABNORMAL_ABORT"
        if state & StateOptions.Syntax:
            return "<F>_SYNTAX_ERROR"
        if state & StateOptions.Fatal:
            return "<F>_ERROR"
        if state & StateOptions.Memory:
            return "<S>_MEMORY_ERROR"
        if state & StateOptions.Convergence:
            return "<S>_NO_CONVERGENCE"
        if state & StateOptions.CpuLimit:
            return "<S>_CPU_LIMIT"
        if state & StateOptions.Except:
            return "<S>_ERROR"
        if state & StateOptions.NoTest:
            return "NO_TEST_RESU"
        if state & StateOptions.Nook:
            return "NOOK_TEST_RESU"
        if state & StateOptions.Warn:
            return "<A>_ALARM"
        if state & StateOptions.Ok:
            return "OK"
        return "?"


RE_OK = re.compile("^ * OK ", re.M)
RE_NOOK = re.compile("^ *NOOK ", re.M)
RE_WARN = re.compile("^ *. *<A>", re.M)
RE_DEBUT = re.compile(re.escape("-- CODE_ASTER -- VERSION"))
RE_FIN = re.compile("<I> <FIN> ARRET NORMAL")
RE_MEM = re.compile("MEMOIRE INSUFFISANTE POUR ALLOUER")
RE_TIME = re.compile("(<TimeLimitError>|ARRET PAR MANQUE DE TEMPS)", re.I)
RE_CONV = re.compile("<(ConvergenceError|IntegrationError|SolverError"
                     "|ContactError)>", re.I)
RE_EXCEPT = re.compile("<AsterError>")
RE_ERRS = re.compile("^ *. *<S>", re.M)
RE_ERRF = re.compile("^ *. *<F>", re.M)
RE_SYNTAX = re.compile("SyntaxError")
RE_ELAPS = re.compile("TOTAL_JOB +" + r": +([0-9\.]+)" * 4)

def get_status(exitcode, output, test=False):
    """Return the diagnostic after a Code_Aster execution.

    Arguments:
        output (str): Output file name or content. If the filename does not
            exist, the string is used as file content.
        test (bool, optional): *True* for a testcase, *False* for a study.

    Returns:
        Status: Status object.
    """
    try:
        with open(output, "rb") as fobj:
            text = fobj.read().decode(errors="replace")
    except FileNotFoundError:
        text = output

    state = 0
    if exitcode == 0:
        nook = RE_NOOK.search(text)
        if nook:
            state |= StateOptions.Nook
        if test and not nook and not RE_OK.search(text):
            state |= StateOptions.NoTest
        if RE_WARN.search(text):
            state |= StateOptions.Warn
        if not state:
            state = StateOptions.Ok
        exitcode = state & (StateOptions.Nook | StateOptions.NoTest)
    else:
        if RE_SYNTAX.search(text):
            state |= StateOptions.Syntax
        if RE_ERRF.search(text):
            state |= StateOptions.Fatal
    if RE_MEM.search(text):
        state |= StateOptions.Memory
    if exitcode == -9 or RE_TIME.search(text):
        state |= StateOptions.CpuLimit
    if RE_CONV.search(text):
        state |= StateOptions.Convergence
    if RE_EXCEPT.search(text) or RE_ERRS.search(text):
        state |= StateOptions.Except
    if not state:
        state = StateOptions.Abort
    state = StateOptions.effective(state)

    ndeb = len(RE_DEBUT.findall(text))
    nfin = len(RE_FIN.findall(text))
    if state & StateOptions.Completed and ndeb != nfin:
        state = StateOptions.Abort

    status = Status(state, exitcode)
    measure = RE_ELAPS.search(text)
    if measure:
        status.times = [float(value) for value in measure.groups()]
    return status


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="get_status",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--exitcode', action='store', type=int, required=True,
                        help="exit code")
    parser.add_argument('--test', action='store_true',
                        help="check status for a testcase")
    parser.add_argument('output',
                        help="output filename")
    args = parser.parse_args()

    status = get_status(args.exitcode, args.output, args.test)
    print('DIAG="{0}"'.format(status.diag))
    print('EXITCODE={0}'.format(status.exitcode))
    print('COMPLETED={0}'.format(int(status.is_completed())))
    sys.exit(0)
