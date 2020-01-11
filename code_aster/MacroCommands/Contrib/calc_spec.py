# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.corus at edf.fr


from ...Cata.Commons import *
from ...Cata.DataStructure import *
from ...Cata.Syntax import *
from ...Supervis.ExecuteCommand import UserMacro
from .calc_spec_ops import calc_spec_ops


CALC_SPEC_CATA=MACRO(nom="CALC_SPEC",
                op=OPS('code_aster.MacroCommands.Contrib.calc_spec_ops.calc_spec_ops'),
                sd_prod=interspectre,
                reentrant='n',
                fr=tr("Calcule une matrice interspectrale ou des fonctions de transferts"),
                regles=(UN_PARMI("ECHANT", "TAB_ECHANT"),
                        UN_PARMI("INTERSPE", "TRANSFERT"), ),
         TAB_ECHANT      =FACT(statut='f',
           NOM_TAB                  =SIMP(statut='o',typ=table_sdaster),
           LONGUEUR_DUREE           =SIMP(statut='f',typ='R'),
           LONGUEUR_POURCENT        =SIMP(statut='f',typ='R'),
           LONGUEUR_NB_PTS          =SIMP(statut='f',typ='I'),
           RECOUVREMENT_DUREE       =SIMP(statut='f',typ='R'),
           RECOUVREMENT_POURCENT    =SIMP(statut='f',typ='R'),
           RECOUVREMENT_NB_PTS      =SIMP(statut='f',typ='I'),
                              ),
         ECHANT          =FACT(statut='f',max='**',
           NUME_ORDRE_I    =SIMP(statut='o',typ='I' ),
           NUME_MES        =SIMP(statut='o',typ='I' ),
           FONCTION        =SIMP(statut='o',typ=fonction_sdaster),
                              ),
#-- Cas de la matrice interspectrale --#
         INTERSPE        =FACT(statut='f',
           FENETRE         =SIMP(statut='f',typ='TXM',defaut="RECT",into=("RECT","HAMM","HANN","EXPO","PART",)),
           BLOC_DEFI_FENE  =BLOC(condition = "FENETRE == 'EXPO' or FENETRE == 'PART' ",
             DEFI_FENE       =SIMP(statut='f',typ='R',max='**'),
                                 ),
                              ),
#-- Cas des transferts - estimateurs H1 / H2 / Hv + Coherence --#
         TRANSFERT       =FACT(statut='f',
           ESTIM           =SIMP(statut='f',typ='TXM',defaut="H1",into=("H1","H2","CO",)),
           REFER           =SIMP(statut='o',typ='I',max='**'),
           FENETRE         =SIMP(statut='f',typ='TXM',defaut="RECT",into=("RECT","HAMM","HANN","EXPO","PART",)),
#           DEFI_FENE       =SIMP(statut='f',typ='R',max='**'),
           BLOC_DEFI_FENE  =BLOC(condition = "FENETRE == 'EXPO' or FENETRE == 'PART' ",
             DEFI_FENE       =SIMP(statut='f',typ='R',max='**'),
                                 ),
                              ),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=( 1 , 2) ),
);

CALC_SPEC = UserMacro("CALC_SPEC", CALC_SPEC_CATA,
                      calc_spec_ops)
