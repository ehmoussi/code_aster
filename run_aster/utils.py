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

import gzip
import os
import os.path as osp
import shutil
import stat
from glob import glob

ROOT = osp.dirname(osp.dirname(osp.dirname(osp.dirname(osp.abspath(__file__)))))


def copy(src, dst):
    """Copy the file or directory `src` to the file or directory `dst`.
    If `dst` specifies a directory, the files will be copied into `dst` using
    the base filenames from `src`.

    Arguments:
        src (str): File or directory to be copied.
        dst (str): Destination.
    """
    if osp.isfile(src):
        shutil.copy2(src, dst)
    else:
        shutil.copytree(src, dst)


def gunzip(path):
    """Decompress a file or the content of a directory.

    Arguments:
        path (str): File or directory path.
    """
    if osp.isfile(path):
        dest = path.rstrip(".gz")
        files = [path]
    else:
        dest = path
        files = glob(osp.join(path, '*'))
    for fname in files:
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
