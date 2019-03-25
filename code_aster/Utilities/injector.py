# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois at edf.fr

"""
:py:mod:`injector` --- Methods injection in Boost Objects
*********************************************************
"""

def injector(boost_class):
    """Return a class object to inject methods into boost objects.

    Arguments:
        boost_class (*boost-python class*): Boost-Python class to enrich.

    Returns:
        class: Injector.
    """
    class injector_class(object):
        class __metaclass__(boost_class.__class__):
            def __init__(self, name, bases, dict):
                for b in bases:
                    if type(b) not in (self, type):
                        for k, v in list(dict.items()):
                            setattr(b, k, v)
                return type.__init__(self, name, bases, dict)

    return injector_class
