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

# person_in_charge: mathieu.courtois at edf.fr


from Noyau import N_MACRO_ETAPE
from Validation import V_MACRO_ETAPE
from Build import B_MACRO_ETAPE
from Execution import E_MACRO_ETAPE


class MACRO_ETAPE(E_MACRO_ETAPE.MACRO_ETAPE,
                  B_MACRO_ETAPE.MACRO_ETAPE, V_MACRO_ETAPE.MACRO_ETAPE,
                  N_MACRO_ETAPE.MACRO_ETAPE):

    def __init__(self, oper=None, reuse=None, args={}):
        N_MACRO_ETAPE.MACRO_ETAPE.__init__(self, oper, reuse, args)
        V_MACRO_ETAPE.MACRO_ETAPE.__init__(self)
        B_MACRO_ETAPE.MACRO_ETAPE.__init__(self)
