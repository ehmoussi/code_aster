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


from Noyau import N_PROC_ETAPE
from Validation import V_PROC_ETAPE
from Build import B_PROC_ETAPE
from Execution import E_PROC_ETAPE


class PROC_ETAPE(E_PROC_ETAPE.PROC_ETAPE,
                 B_PROC_ETAPE.PROC_ETAPE, V_PROC_ETAPE.PROC_ETAPE,
                 N_PROC_ETAPE.PROC_ETAPE):

    def __init__(self, oper=None, args={}):
        # Pas de constructeur pour B_PROC_ETAPE.PROC_ETAPE
        N_PROC_ETAPE.PROC_ETAPE.__init__(self, oper=oper, args=args)
        V_PROC_ETAPE.PROC_ETAPE.__init__(self)
