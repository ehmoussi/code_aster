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

# person_in_charge: mathieu.courtois@edf.fr


def ExactlyOne( keywords, args ):
    """Check that exactly one argument listed in 'args' is defined in
    'keywords'"""
    not_none = [keywords.has_key(i) for i in args]
    if sum(not_none) != 1:
        raise NameError("Exactly one argument of {} is required".format(args))

def Together( keywords, args ):
    """All arguments must be all defined or all undefined"""
    not_none = [keywords.has_key(i) for i in args]
    if sum(not_none) not in ( 0, len(args) ):
        raise NameError("{} must be all defined or all undefined".format(args))
