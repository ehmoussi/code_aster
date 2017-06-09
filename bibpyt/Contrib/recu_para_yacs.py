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
# RECUPERATION DE PARAMETRES DE COUPLAGE VIA YACS
#

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


RECU_PARA_YACS=OPER(nom="RECU_PARA_YACS",op=114,sd_prod=listr8_sdaster,
                   reentrant = 'n',
                   fr        = tr("Gestion des scalaires via YACS pour le coupleur IFS"),
          DONNEES = SIMP(statut='o',typ='TXM',into=("INITIALISATION","CONVERGENCE","FIN","PAS",) ),
          b_init   = BLOC(condition= "DONNEES=='INITIALISATION'",
                     PAS             = SIMP(statut='o',typ='R', ),),
          b_noinit = BLOC(condition= "(DONNEES=='CONVERGENCE')or(DONNEES=='FIN')",
                     NUME_ORDRE_YACS = SIMP(statut='o', typ='I',),
                     INST         = SIMP(statut='o',typ='R', ),
                     PAS             = SIMP(statut='o',typ='R', ),),
          b_pastps = BLOC(condition= "(DONNEES=='PAS')",
                     NUME_ORDRE_YACS = SIMP(statut='o', typ='I',),
                     INST         = SIMP(statut='o',typ='R', ),
                     PAS             = SIMP(statut='o',typ='R', ),),
         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2)),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
);
