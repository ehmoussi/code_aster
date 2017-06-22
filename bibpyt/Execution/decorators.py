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

"""Collection of decorators"""

import sys
import traceback
from functools import wraps


def jdc_required(method):
    """decorator to check that the jdc attribute has been initialized"""
    @wraps(method)
    def wrapper(inst, *args, **kwds):
        """wrapper"""
        assert inst.jdc is not None, 'jdc must be initialized (call InitJDC(...) before)'
        return method(inst, *args, **kwds)
    return wrapper


def stop_on_returncode(method):
    """decorator that calls the interrupt method if the returncode
    is not null"""
    @wraps(method)
    def wrapper(inst, *args, **kwds):
        """wrapper"""
        errcode = method(inst, *args, **kwds)
        if errcode:
            inst.interrupt(errcode)
        return errcode
    return wrapper


def never_fail(func):
    """decorator to wrap functions that must never fail"""
    @wraps(func)
    def wrapper(*args, **kwds):
        """wrapper"""
        try:
            ret = func(*args, **kwds)
        except Exception, exc:
            traceback.print_exc(file=sys.stdout)
            print 'continue...'
            ret = None
        return ret
    return wrapper
