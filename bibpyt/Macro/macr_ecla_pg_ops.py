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

import os

from code_aster.Cata.Syntax import _F
from code_aster.Commands import CREA_MAILLAGE, CREA_RESU


def macr_ecla_pg_ops(self, RESULTAT, MAILLAGE, RESU_INIT, MODELE_INIT,
                     TOUT=None, GROUP_MA=None, MAILLE=None,
                     SHRINK=None, TAILLE_MIN=None,
                     NOM_CHAM=None, TOUT_ORDRE=None, NUME_ORDRE=None, LIST_ORDRE=None,
                     INST=None, LIST_INST=None, PRECISION=None, CRITERE=None,
                     **args):
    """
       Ecriture de la macro macr_ecla_pg
    """

    # On importe les definitions des commandes a utiliser dans la macro

    # Appel à CREA_MAILLAGE :
    motscles = {}
    if TOUT:
        motscles['TOUT'] = TOUT
    if GROUP_MA:
        motscles['GROUP_MA'] = GROUP_MA
    if MAILLE:
        motscles['MAILLE'] = MAILLE

    ma2 = CREA_MAILLAGE(ECLA_PG=_F(MODELE=MODELE_INIT,  NOM_CHAM=NOM_CHAM,
                                   SHRINK=SHRINK, TAILLE_MIN=TAILLE_MIN, **motscles))
    self.register_result(ma2, MAILLAGE)

    # Appel à CREA_RESU :
    if TOUT_ORDRE:
        motscles['TOUT_ORDRE'] = TOUT_ORDRE
    if NUME_ORDRE is not None:
        motscles['NUME_ORDRE'] = NUME_ORDRE
    if LIST_ORDRE:
        motscles['LIST_ORDRE'] = LIST_ORDRE
    if LIST_INST:
        motscles['LIST_INST'] = LIST_INST
    if INST is not None:
        motscles['INST'] = INST

    resu2 = CREA_RESU(OPERATION='ECLA_PG', TYPE_RESU=RESU_INIT.getType(),
                      ECLA_PG=_F(
                      MODELE_INIT=MODELE_INIT, RESU_INIT=RESU_INIT, NOM_CHAM=NOM_CHAM,
                                MAILLAGE=ma2, **motscles))
    resu2.appendModelOnAllRanks(MODELE_INIT)
    self.register_result(resu2, RESULTAT)
    return
#
