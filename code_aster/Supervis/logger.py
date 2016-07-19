# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

"""
This module defines a logger object and error functions for the package

A trace.log file is also opened for detailed traceback.
"""

import sys
import logging
from functools import partial
import tempfile

# using these values allows to use them as `lvl` in `logger.log(lvl, ...)`
ERROR = logging.ERROR
WARN = logging.WARNING
INFO = logging.INFO
OK = INFO
DEBUG = logging.DEBUG

RETURNCODE = { OK : 0, DEBUG : 0, WARN : 2, ERROR : 4 }
assert OK < WARN < ERROR, (OK, WARN, ERROR)

class PerLevelFormatter(logging.Formatter):
    """Formatter for messages"""

    def _adjust_format(self, level):
        """Adjust the format for the given level"""
        if level != logging.INFO:
            self._fmt = "%(levelname)-7s %(message)s"
        else:
            self._fmt = "%(message)s"

    def format(self, record):
        """Enhance error and warning messages"""
        lvl = record.levelno
        self._adjust_format(lvl)
        return logging.Formatter.format(self, record)


class PerLevelColorFormatter(PerLevelFormatter):
    """Formatter for messages"""

    def _adjust_color(self, level):
        """Choose a color function according to the level"""
        func = lambda message: message
        if level >= logging.ERROR:
            func = red
        elif level >= logging.WARN:
            func = blue
        return func

    def format(self, record):
        """Enhance error and warning messages"""
        lvl = record.levelno
        return self._adjust_color(lvl)(PerLevelFormatter.format(self, record))


class HgStreamHandler(logging.StreamHandler):
    """StreamHandler switching between sys.stdout and sys.stderr
    like the mercurial ui does"""

    def _adjust_stream(self, level):
        """Adjust the stream according to the given level"""
        self.flush()
        if level >= logging.WARNING:
            self.stream = sys.stderr
        else:
            self.stream = sys.stdout

    def emit(self, record):
        """Enhance error and warning messages"""
        self._adjust_stream(record.levelno)
        return logging.StreamHandler.emit(self, record)


def build_logger(level=logging.WARN):
    """Initialize the logger with its handlers"""
    logger = logging.getLogger("code_aster")
#    logger.setLevel(logging.DEBUG)
    logger.setLevel(level)
    term = HgStreamHandler(sys.stdout)
    term.setFormatter(PerLevelFormatter())
    logger.addHandler(term)
    return logger

def setlevel(*dummy, **kwargs):
    """Callback for verbose/debug option"""
    lvl = kwargs.get('level', logging.DEBUG)
    logger.setLevel(lvl)

logger = build_logger()

_logfile = None
def tracelog(dir=None):
    """Open the log file for detailed output"""
    global _logfile
    if _logfile is None:
        fname = tempfile.NamedTemporaryFile(dir=dir, prefix='code_aster_trace_',
                                            suffix='.log').name
        _logfile = open(fname, 'wb')
    return _logfile

def close_tracelog(write=None):
    """Close (and remove) the log file"""
    global _logfile
    if _logfile:
        _logfile.close()
        if write:
            write(open(_logfile.name, 'rb').read())
        _logfile = None

COLOR = {
    'red' : r'\033[1;31m',
    'green' : r'\033[1;32m',
    'blue' : r'\033[1;34m',
    'grey' : r'\033[1;30m',
    'magenta' : r'\033[1;35m',
    'cyan' : r'\033[1;36m',
    'yellow' : r'\033[1;33m',
    'endc' : r'\033[1;m',
}

_colored = sys.stdout.isatty()

def _colorize(color, string):
    """Return the colored `string`"""
    if not _colored or not string.strip():
        return string
    return COLOR[color] + string + COLOR['endc']

red = partial(_colorize, 'red')
green = partial(_colorize, 'green')
blue = partial(_colorize, 'blue')
magenta = partial(_colorize, 'magenta')
cyan = partial(_colorize, 'cyan')
yellow = partial(_colorize, 'yellow')
grey = partial(_colorize, 'grey')
