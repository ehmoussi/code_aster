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
:py:mod:`utils` --- Utilities
-----------------------------

This module provides convenient utilities for files manipulation,
system command execution, templates...
"""


import gzip
import os
import os.path as osp
import re
import shutil
import stat
import string
import sys
import time
from glob import glob
from subprocess import TimeoutExpired, run

from .logger import logger

# installation root is defined by launcher script or relatively to this file
ROOT = os.environ.get("RUNASTER_ROOT",
    osp.dirname(osp.dirname(osp.dirname(osp.dirname(osp.abspath(__file__))))))


def copy(src, dst, verbose=False):
    """Copy the file or directory `src` to the file or directory `dst`.
    If `src` is a file, `dst` can be an existing directory or the destination
    file name.
    If `src` is a directory and `dst` is an existing directory, the files
    will be copied into `dst`.
    Parent directory of `dst` is created if necessary.

    If `dst` specifies a directory, the files will be copied into `dst` using
    the base filenames from `src`.

    Arguments:
        src (str): File or directory to be copied.
        dst (str): Destination.
        verbose (bool): Verbosity.
    """
    if verbose:
        logger.info(f"copying '{src}' to '{dst}'...")
    pardst = osp.dirname(osp.abspath(dst))
    if not osp.exists(pardst):
        os.makedirs(pardst)
    if osp.isfile(src):
        shutil.copy2(src, dst)
    else:
        if not osp.isdir(dst):
            shutil.copytree(src, dst)
        else:
            for fname in os.listdir(src):
                if osp.isdir(osp.join(src, fname)):
                    copy(osp.join(src, fname),
                         osp.join(dst, osp.basename(fname)),
                         verbose=verbose)
                else:
                    copy(osp.join(src, fname), dst, verbose=verbose)


def compress(path, verbose=False):
    """Compress a file or the content of a directory.

    Arguments:
        path (str): File or directory path.
        verbose (bool): Verbosity.
    """
    if osp.isfile(path):
        dest = path + ".gz"
        files = [path]
    else:
        dest = path
        files = glob(osp.join(path, '*'))
    for fname in files:
        if verbose:
            tail = fname if len(fname) < 60 else "[...]" + fname[-60:]
            logger.info(f"compressing '{tail}'...")
        with open(fname, 'rb') as f_in:
            with gzip.open(fname + ".gz", 'wb', compresslevel=6) as f_out:
                shutil.copyfileobj(f_in, f_out)
    return dest


def uncompress(path, verbose=False):
    """Decompress a file or the content of a directory.

    Arguments:
        path (str): File or directory path.
        verbose (bool): Verbosity.
    """
    if osp.isfile(path):
        dest = path.rstrip(".gz")
        files = [path]
    else:
        dest = path
        files = glob(osp.join(path, '*.gz'))
    for fname in files:
        if verbose:
            tail = fname if len(fname) < 60 else "[...]" + fname[-60:]
            logger.info(f"decompressing '{tail}'...")
        with gzip.open(fname, 'rb') as f_in:
            with open(fname.rstrip(".gz"), 'wb') as f_out:
                shutil.copyfileobj(f_in, f_out)
    return dest


def make_writable(filename):
    """Force a file to be writable by the current user.

    Arguments:
        filename (str): File name.
    """
    os.chmod(filename, os.stat(filename).st_mode | stat.S_IWUSR)


def run_command(cmd, timeout=None, exitcode_file=None):
    """Execute a command and duplicate output to `logfile`.

    Arguments:
        cmd (list): Command line arguments.
        timeout (float, optional): Time out for the execution.
        exitcode_file (str, optional): Read exit code from this file if
            it exists.

    Returns:
        int: exit code.
    """
    try:
        proc = run(" ".join(cmd), shell=True, timeout=timeout or None)
        iret = proc.returncode
        if exitcode_file and osp.isfile(exitcode_file):
            with open(exitcode_file) as fexit:
                iret = int(fexit.read())
            os.remove(exitcode_file)
    except TimeoutExpired as exc:
        sys.stderr.write(str(exc))
        iret = -9
    return iret

def cmd_abspath(prog):
    """Return the absolute path of a program as found in PATH.

    If `prog` contains a '/', it is returned unchanged.

    Arguments:
        prog (str): Executable or script.

    Returns:
        str: Absolute path to run `prog`.
    """
    if os.sep not in prog:
        for path in os.getenv("PATH").split(os.pathsep):
            if osp.isfile(osp.join(path, prog)):
                prog = osp.join(path, prog)
                break
    return prog
