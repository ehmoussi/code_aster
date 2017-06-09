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

# person_in_charge: nicolas.greffet at edf.fr
#
# RECUPERATION DES MAILLAGES IFS VENANT DE SATURNE VIA YACS
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


IMPR_MAIL_YACS=PROC(nom="IMPR_MAIL_YACS",op=43,
               fr=tr("Lecture d'un maillage via YACS lors du Couplage de Code_Aster et Saturne"),
         UNITE_MAILLAGE = SIMP(statut='f',typ='I',defaut=30),
         TYPE_MAILLAGE = SIMP(statut='o',typ='TXM',into=("SOMMET","MILIEU")),
         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2)),
)  ;
