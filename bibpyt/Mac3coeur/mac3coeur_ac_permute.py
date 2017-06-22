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

# person_in_charge: samuel.geniaut at edf.fr

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

# ------------------------------------------------------------------------


def mac3coeur_ac_permute(self, **args):
    """Methode corps de la macro MACRO_AC_PERMUTE"""
    from code_aster.Cata.Syntax import _F

    ier = 0
    nompro = 'MACRO_AC_PERMUTE'

    # On importe les definitions des commandes a utiliser dans la macro
    EXTR_RESU = self.get_cmd('EXTR_RESU')
    CREA_CHAMP = self.get_cmd('CREA_CHAMP')
    CREA_RESU = self.get_cmd('CREA_RESU')

    POS_INIT = self['POS_INIT']
    POS_FIN = self['POS_FIN']
    RESU_INI = self['RESU_INI']
    RESU_FIN = self['RESU_FIN']
    INSTANT = self['INSTANT']
    MA_INI = self['MAILLAGE_INIT']
    MA_FIN = self['MAILLAGE_FINAL']
    MO_FIN = self['MODELE_FINAL']
    VECT = self['TRAN']

    # La macro compte pour 1 dans l'execution des commandes
    self.set_icmd(1)

    CREA_RESU(reuse=RESU_FIN,
              OPERATION='PERM_CHAM',
              TYPE_RESU='EVOL_NOLI',
              RESU_INIT=RESU_INI,
              INST_INIT=INSTANT,
              MAILLAGE_INIT=MA_INI,
              NOM_CHAM='DEPL',
              RESU_FINAL=RESU_FIN,
              MAILLAGE_FINAL=MA_FIN,
              PERM_CHAM=(_F(GROUP_MA_INIT='CR_' + POS_INIT,
                            GROUP_MA_FINAL='CR_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='TG_' + POS_INIT,
                            GROUP_MA_FINAL='TG_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='ES_' + POS_INIT,
                            GROUP_MA_FINAL='ES_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='EI_' + POS_INIT,
                            GROUP_MA_FINAL='EI_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='DI_' + POS_INIT,
                            GROUP_MA_FINAL='DI_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GC_' + POS_INIT + '_B',
                            GROUP_MA_FINAL='GC_' + POS_FIN + '_B',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GC_' + POS_INIT + '_T',
                            GROUP_MA_FINAL='GC_' + POS_FIN + '_T',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GC_' + POS_INIT + '_M',
                            GROUP_MA_FINAL='GC_' + POS_FIN + '_M',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GT_' + POS_INIT + '_E',
                            GROUP_MA_FINAL='GT_' + POS_FIN + '_E',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GT_' + POS_INIT + '_M',
                            GROUP_MA_FINAL='GT_' + POS_FIN + '_M',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='MNT_' + POS_INIT,
                            GROUP_MA_FINAL='MNT_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),))

    CREA_RESU(reuse=RESU_FIN,
              OPERATION='PERM_CHAM',
              TYPE_RESU='EVOL_NOLI',
              RESU_INIT=RESU_INI,
              INST_INIT=INSTANT,
              MAILLAGE_INIT=MA_INI,
              NOM_CHAM='VARI_ELGA',
              RESU_FINAL=RESU_FIN,
              MAILLAGE_FINAL=MA_FIN,
              PERM_CHAM=(_F(GROUP_MA_INIT='CR_' + POS_INIT,
                            GROUP_MA_FINAL='CR_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='TG_' + POS_INIT,
                            GROUP_MA_FINAL='TG_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='ES_' + POS_INIT,
                            GROUP_MA_FINAL='ES_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='EI_' + POS_INIT,
                            GROUP_MA_FINAL='EI_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='DI_' + POS_INIT,
                            GROUP_MA_FINAL='DI_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GC_' + POS_INIT + '_B',
                            GROUP_MA_FINAL='GC_' + POS_FIN + '_B',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GC_' + POS_INIT + '_T',
                            GROUP_MA_FINAL='GC_' + POS_FIN + '_T',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GC_' + POS_INIT + '_M',
                            GROUP_MA_FINAL='GC_' + POS_FIN + '_M',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GT_' + POS_INIT + '_E',
                            GROUP_MA_FINAL='GT_' + POS_FIN + '_E',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='GT_' + POS_INIT + '_M',
                            GROUP_MA_FINAL='GT_' + POS_FIN + '_M',
                            TRAN=VECT,
                            PRECISION=1.E-10),
                         _F(GROUP_MA_INIT='MNT_' + POS_INIT,
                            GROUP_MA_FINAL='MNT_' + POS_FIN,
                            TRAN=VECT,
                            PRECISION=1.E-10),))

    return ier

MACRO_AC_PERMUTE = MACRO(nom="MACRO_AC_PERMUTE",
                         op=mac3coeur_ac_permute,
                         fr="PERMUTATION DES ASSEMBLAGES",
                         POS_INIT=SIMP(statut='o', typ='TXM',),
                         POS_FIN=SIMP(statut='o', typ='TXM',),
                         RESU_INI=SIMP(statut='o', typ=evol_noli),
                         RESU_FIN=SIMP(statut='o', typ=evol_noli),
                         INSTANT=SIMP(
                         statut='o', typ='R', validators=NoRepeat(), max=1),
                         MAILLAGE_INIT=SIMP(statut='o', typ=maillage_sdaster,),
                         MAILLAGE_FINAL=SIMP(
                             statut='o', typ=maillage_sdaster,),
                         MODELE_FINAL=SIMP(statut='o', typ=modele_sdaster),
                         TRAN=SIMP(statut='o', typ='R', min=3, max=3),
                         )
