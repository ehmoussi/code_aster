# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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
This module defines some utilities that should be replaced
by pure Python modules as soon as the fortran can use them.
"""

# fortran "call affich()" should be replaced something like:
# "call affich('MESSAGE', text) -> logger.info(text)"
# "call affich('ERREUR', text) -> logger.error(text)"
# "call affich('RESULTAT', text) -> logger.result(text) or a specific logger"
def writeInMess(text):
    """Write a text in the result file"""
    libaster.affich('MESSAGE', text)

def writeInResu(text):
    """Write a text in the result file"""
    libaster.affich('RESULTAT', text)
