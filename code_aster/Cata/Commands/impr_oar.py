# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: isabelle.fournier at edf.fr
#
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


IMPR_OAR =MACRO(nom="IMPR_OAR",
                op=OPS('Macro.impr_oar_ops.impr_oar_ops'),
                sd_prod=None,
                fr=tr("Impression au format OAR"),
   TYPE_CALC = SIMP(statut='o', typ='TXM',into=('COMPOSANT', 'MEF', 'TUYAUTERIE')),
   b_composant =BLOC(condition = """equal_to("TYPE_CALC", 'COMPOSANT') """,
      regles = (AU_MOINS_UN('RESU_MECA','RESU_THER')),
      DIAMETRE = SIMP(statut='o', typ='R'),
      ORIGINE  = SIMP(statut='f', typ='TXM', defaut='INTERNE', into=('INTERNE', 'EXTERNE')),
      COEF_U   = SIMP(statut='f', typ='R',   defaut=1.0),
      ANGLE_C  = SIMP(statut='f', typ='R',   defaut=0.0),
      REVET    = SIMP(statut='f', typ='TXM', defaut='NON', into=('OUI', 'NON')),
      RESU_MECA = FACT(statut='f', max='**',
         NUM_CHAR  = SIMP(statut='o', typ='I'),
         TYPE      = SIMP(statut='f', typ='TXM', defaut='FX', into=('FX', 'FY', 'FZ', 'MX', 'MY', 'MZ', 'PRE')),
         TABLE     = SIMP(statut='o', typ=table_sdaster),
         TABLE_S   = SIMP(statut='f', typ=table_sdaster)),
      RESU_THER = FACT(statut='f', max='**',
         NUM_TRAN  = SIMP(statut='o', typ='I'),
         TABLE_T   = SIMP(statut='o', typ=table_sdaster),
         TABLE_TEMP= SIMP(statut='o', typ=table_sdaster),
         TABLE_S   = SIMP(statut='f', typ=table_sdaster),
         TABLE_ST  = SIMP(statut='f', typ=table_sdaster)),
         ),
   b_mef = BLOC(condition = """equal_to("TYPE_CALC", 'MEF') """,
      regles = (AU_MOINS_UN('RESU_MECA','RESU_THER')),
      DIAMETRE = SIMP(statut='o', typ='R'),
      ORIGINE  = SIMP(statut='f', typ='TXM', defaut='INTERNE', into=('INTERNE', 'EXTERNE')),
      COEF_U   = SIMP(statut='f', typ='R',   defaut=1.0),
      RESU_MECA = FACT(statut='f', max='**',
         AZI       = SIMP(statut='o', typ='R'),
         TABLE_T   = SIMP(statut='o', typ=table_sdaster),
         TABLE_F   = SIMP(statut='o', typ=table_sdaster),
         TABLE_P   = SIMP(statut='o', typ=table_sdaster),
         TABLE_CA  = SIMP(statut='o', typ=table_sdaster)),
      RESU_THER=FACT(statut='f', max='**',
         AZI       = SIMP(statut='o', typ='R'),
         NUM_CHAR  = SIMP(statut='o', typ='I'),
         TABLE_T   = SIMP(statut='o', typ=table_sdaster),
         TABLE_TI  = SIMP(statut='o', typ=table_sdaster)),
      ),
   b_tuyauterie = BLOC(condition = """equal_to("TYPE_CALC", 'TUYAUTERIE') """,
      RESU_MECA = FACT(statut='o', max='**',
         NUM_CHAR  = SIMP(statut='o', typ='I'),
         TABLE     = SIMP(statut='o', typ=table_sdaster),
         MAILLAGE  = SIMP(statut='o', typ=maillage_sdaster)),
         ),
   UNITE = SIMP(statut='f',typ=UnitType(),defaut=38, inout='out'),
   AJOUT = SIMP(statut='f', typ='TXM', defaut='NON', into=('OUI', 'NON')),
   );
