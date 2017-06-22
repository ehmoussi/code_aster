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

# person_in_charge: mickael.abbas at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *


def C_RECH_LINEAIRE() : return FACT(statut='f',
           METHODE         =SIMP(statut='f',typ='TXM',defaut="CORDE",into=("CORDE","MIXTE","PILOTAGE") ),
           RESI_LINE_RELA  =SIMP(statut='f',typ='R',defaut= 1.0E-1 ),
           ITER_LINE_MAXI  =SIMP(statut='f',typ='I',defaut= 3,val_max=999),
           RHO_MIN         =SIMP(statut='f',typ='R',defaut=1.0E-2),
           RHO_MAX         =SIMP(statut='f',typ='R',defaut=1.0E+1),
           RHO_EXCL        =SIMP(statut='f',typ='R',defaut=0.9E-2,val_min=0.),
         );
