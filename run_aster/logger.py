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
:py:mod:`logger` --- Logging and messages output
************************************************

This module defines a logger object and error functions.
All message outputs should pass by this object.
Probably additional levels should be added to distinguish low-debug messages,
debug messages that may be interesting for the user (equivalent to
``INFO=2``)...
It might be necessary to refactor it in C++ for better performance and a
global access (no C interface currently)...

.. todo:: Not used anymore, remove ?
    A :file:`trace.log` file is also opened for detailed traceback.
"""

import logging
import os
import sys
import tempfile
from functools import partial

# using these values allows to use them as `lvl` in `logger.log(lvl, ...)`
ERROR = logging.ERROR
WARNING = logging.WARNING
INFO = logging.INFO
OK = INFO
DEBUG = logging.DEBUG

RETURNCODE = {OK: 0, DEBUG: 0, WARNING: 2, ERROR: 4}
assert OK < WARNING < ERROR, (OK, WARNING, ERROR)


class PerLevelFormatter(logging.Formatter):

    """Formatter for messages"""

    formats = {
        ERROR: "ERROR: %(msg)s",
        WARNING: "WARNING: %(msg)s",
        INFO: "%(msg)s",
        DEBUG: "DEBUG: %(msg)s",
    }

    def format(self, record):
        """Enhance error and warning messages"""
        log_fmt = self.formats.get(record.levelno, self.formats[INFO])
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)


class PerLevelColorFormatter(PerLevelFormatter):

    """Formatter for messages"""

    def _adjust_color(self, level):
        """Choose a color function according to the level"""
        func = lambda message: message
        if level >= ERROR:
            func = red
        elif level >= WARNING:
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
        if level >= WARNING:
            self.stream = sys.stderr
        else:
            self.stream = sys.stdout

    def emit(self, record):
        """Enhance error and warning messages"""
        self._adjust_stream(record.levelno)
        return logging.StreamHandler.emit(self, record)


def build_logger(level=INFO, raise_exception=True):
    """Initialize the logger with its handlers.

    Arguments:
        level (int): Logging level.
        raise_exception (bool): If *True* (default), an exception is raised in
            case of error.

    Returns:
        Logger: logger object.
    """
    logger = logging.getLogger("run_aster")
    # keep only debug, info and error
    logger.critical = logger.fatal = None
    if int(os.getenv("DEBUG", 0)):
        level = DEBUG
    logger.setLevel(level)
    term = HgStreamHandler(sys.stdout)
    term.setFormatter(PerLevelFormatter())
    logger.addHandler(term)

    if raise_exception:
        logger._error_orig = logger.error

        def _error(self, *args, **kwargs):
            exception = kwargs.pop("exception", RuntimeError)
            logger._error_orig(self, *args, **kwargs)
            raise exception

        logger.error = _error

    return logger


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
    'red': r'\033[1;31m',
    'green': r'\033[1;32m',
    'blue': r'\033[1;34m',
    'grey': r'\033[1;30m',
    'magenta': r'\033[1;35m',
    'cyan': r'\033[1;36m',
    'yellow': r'\033[1;33m',
    'endc': r'\033[1;m',
}

try:
    _colored = sys.stdout.isatty()
except AttributeError:
    _colored = False


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
