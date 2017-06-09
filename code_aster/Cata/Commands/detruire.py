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

# person_in_charge: j-pierre.lefebvre at edf.fr
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


DETRUIRE=MACRO(nom="DETRUIRE",
               op=OPS("code_aster.Cata.ops.DETRUIRE"),
               fr=tr("Détruit des concepts utilisateurs dans la base GLOBALE ou des objets JEVEUX"),
               op_init=ops.build_detruire,
    regles=(UN_PARMI('CONCEPT', 'OBJET',),),

    CONCEPT = FACT(statut='f',max='**',
        NOM         = SIMP(statut='o',typ=assd,validators=NoRepeat(),max='**'),
    ),
    OBJET = FACT(statut='f',max='**',
       CLASSE   = SIMP(statut='f', typ='TXM', into=('G', 'V', 'L'), defaut='G'),
       CHAINE   = SIMP(statut='o', typ='TXM', validators=NoRepeat(), max='**'),
       POSITION = SIMP(statut='f', typ='I', max='**'),
    ),
    INFO   = SIMP(statut='f', typ='I', into=(1, 2), defaut=1, ),
)
