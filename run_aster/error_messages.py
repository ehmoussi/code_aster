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
:py:mod:`error_messages` --- Extract error messages from an execution
---------------------------------------------------------------------

This module defines functions to extract the error messages from the output
file of an execution.
"""

# This modules is common with asterstudy except that it works on '.mess' file

import os
import re
from collections import OrderedDict
from math import log10

CMDTAG = re.compile(r"\.\. __(?P<orig>run|stg)(?P<stgnum>[0-9]+)_"
                    r"(?P<loc>cmd|txt)(?P<id>[0-9]+(:[0-9]+)?)")
SEPAR = "EXECUTION_CODE_ASTER_EXIT_"


def search_msg(text, maxlines=100000):
    """Return all messages found in a text.

    Arguments:
        text (str): Output of a code_aster execution.
        maxlines (int): Parse only the last `maxlines` lines.

    Returns:
        dict: Ordered Dict of list of messages, indexed by command identifier.
    """
    def run_id(irun, line=1):
        "Return an identifier for Runner messages."
        return "run{0}_txt{1}".format(irun, line)

    separ, _ = _regexp_decoration()

    # must be consistent with usage of marker used in code_aster
    expr = re.compile(r"(^[0-9]+:(?:"
                      r"\.\. __stg[0-9]+_\w+[0-9]+(:[0-9]+)?|"
                      r" *![-]{3}[-]*?!.*?![-]{3}[-]*?!|"
                      r" *" + separ + r".*?" + separ + r"|"
                      r" *<(?:INFO|A|F)>.*?$|"
                      r"Traceback \(most recent call last\)|"
                      r"\w*Error:.*?$|"
                      r">> JDC.py : DEBUT RAPPORT|"
                      r" *" + SEPAR + ".*?$"
                      r"))",
                      re.M | re.DOTALL)
    outofcmd = re.compile("(>> JDC.py : DEBUT RAPPORT|" + SEPAR + ")", re.M)

    # attach first messages to the Runner (also if there is no tag)
    irun = 0
    current = run_id(irun)
    dmsg = OrderedDict()
    closure = None

    # take only the last 'maxlines' lines
    _lines = text.splitlines()
    if len(_lines) > maxlines:
        text = os.linesep.join(_lines[-maxlines:])
        closure = (1, "<A> Only the messages found in the last "
                      "{0} lines have been analyzed.".format(maxlines))

    # text = remove_mpi_prefix(text) # not needed in '.mess' file
    text = _add_line_numbers(text)

    for mat_i in expr.finditer(text):
        text_i = mat_i.group(0)
        # print "DEBUG: current", current, "\n", text_i, "\n" + "+" * 80
        mat = CMDTAG.search(text_i)
        if mat:
            current = "{orig}{stgnum}_{loc}{id}".format(**mat.groupdict())
            continue
        line, cleaned = _remove_decoration(text_i)
        mat = outofcmd.search(text_i)
        if mat:
            irun += 1
            current = run_id(irun, line)
        dmsg.setdefault(current, [])
        dmsg[current].append((line, cleaned))

    if closure:
        dmsg.setdefault(current, [])
        dmsg[current].append(closure)
    return dmsg


def _remove_decoration(text):
    """Remove the message decoration.

    Arguments:
        text (str): Text of a message.

    Returns:
        str: Message without its decoration.
    """
    separ, avert = _regexp_decoration()

    line, text = _remove_line_numbers(text)
    rsepar = re.compile(separ, re.M)
    left = re.compile("^ *" + avert, re.M)
    right = re.compile(avert + " *$", re.M)
    text = rsepar.sub("", text)
    text = left.sub("", text)
    text = right.sub("", text)
    text = text.strip()
    return line, text


def _regexp_decoration():
    """Return regular expressions to search for the horizontal and vertical
    markers of decorated messages
    """
    upleft = chr(0x2554)
    upright = chr(0x2557)
    horiz = chr(0x2550)
    vert = chr(0x2551)
    botleft = chr(0x255a)
    botright = chr(0x255d)
    aleft = "[!" + upleft + botleft + "]"
    aright = "[!" + upright + botright + "]"
    ahoriz = "[-" + horiz + "]"
    avert = "[!" + vert + "]"
    separ = aleft + ahoriz + "{3}" + ahoriz + "*?" + aright
    return separ, avert


def _add_line_numbers(text):
    """
    Insert line numbers at the beginning of the log of code_aster execution.

    Arguments:
        text(str): Log (output) of code_aster execution.
    """
    lines = text.splitlines()
    # 0 not an admissible value for the log
    nbl = max(len(lines), 1)
    fmt = '{{0:0{}d}}:{{1}}'.format(int(log10(nbl)) + 1)
    lines = [fmt.format(i + 1, line) for i, line in enumerate(lines)]
    return os.linesep.join(lines)


def _remove_line_numbers(text):
    number = re.compile("^([0-9]+):", re.M)
    mat_line = number.search(text)
    line = 0
    if mat_line:
        line = int(mat_line.group(1))
        text = number.sub("", text)
    return line, text
