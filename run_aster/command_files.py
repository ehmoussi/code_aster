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

# imports are in a string
# aslint: disable=C4009

"""
:py:mod:`command_files` --- Changing commands files
---------------------------------------------------

This modules provides some functions that change commands files.
"""

import re


AUTO_IMPORT = """
# temporarly added for compatibility with code_aster legacy
from math import *

import code_aster
from code_aster.Commands import *

{starter}"""

def add_import_commands(text):
    """Add import of code_aster commands if not present.

    Arguments:
        filename (str): Path of the comm file to check.
        text (str): Text of a command file.

    Returns:
        str: Changed content.
    """
    re_done = re.compile(r"^from +code_aster\.Commands", re.M)
    if re_done.search(text):
        return text

    re_init = re.compile("^(?P<init>(DEBUT|POURSUITE))", re.M)
    if re_init.search(text):
        starter = r"\g<init>"
        text = re_init.sub(AUTO_IMPORT.format(starter=starter), text)

    re_coding = re.compile(r'^#( *(?:|\-\*\- *|en)coding.*)' + '\n', re.M)
    if not re_coding.search(text):
        text = "# coding=utf-8\n" + text

    return text


def stop_at_end(text):
    """Stop execution raising *EOFError* instead of calling ``FIN()``.

    Arguments:
        text (str): Text of a command file.

    Returns:
        str: Changed content.
    """
    refin = re.compile(r"^(?P<cmd>(FIN|code_aster\.close) *\()", re.M)
    subst = \
r"""
import code
import readline
import rlcompleter

readline.parse_and_bind('tab: complete')

code.interact(local=locals(),
                banner=('\\nEntering in interactive mode\\n'
                        'Use exit() or Ctrl-D (i.e. EOF) to continue '
                        'with \g<cmd>...)'),
                exitmsg='Use exit() or Ctrl-D (i.e. EOF) to exit')

\g<cmd>
"""
    text = refin.sub(subst, text)
    return text
