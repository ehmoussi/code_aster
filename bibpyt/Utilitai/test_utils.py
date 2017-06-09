# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

"""Utilities for unittests embedded inside Code_Aster python modules"""

import difflib
import base64
import zlib


def uncompress64(compressed):
    """uncompress"""
    return zlib.decompress(base64.decodestring(compressed))


def compress64(uncompressed):
    """compress"""
    return base64.encodestring(zlib.compress(uncompressed))


def difftxt(old, new, fromfile='old', tofile='new'):
    """diff of string"""
    return ''.join(difflib.unified_diff(old.splitlines(1), new.splitlines(1),
                                        fromfile=fromfile, tofile=tofile))
