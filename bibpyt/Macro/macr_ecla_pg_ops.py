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

#


def macr_ecla_pg_ops(self, RESULTAT, MAILLAGE, RESU_INIT, MODELE_INIT,
                     TOUT, GROUP_MA, MAILLE,
                     SHRINK, TAILLE_MIN,
                     NOM_CHAM, TOUT_ORDRE, NUME_ORDRE, LIST_ORDRE, INST, LIST_INST, PRECISION, CRITERE,
                     **args):
    """
       Ecriture de la macro macr_ecla_pg
    """
    import os
    import string
    from code_aster.Cata.Syntax import _F
    from Noyau.N_utils import AsType
    ier = 0

    # On importe les definitions des commandes a utiliser dans la macro
    CREA_MAILLAGE = self.get_cmd('CREA_MAILLAGE')
    CREA_RESU = self.get_cmd('CREA_RESU')

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # Appel à CREA_MAILLAGE :
    motscles = {}
    if TOUT:
        motscles['TOUT'] = TOUT
    if GROUP_MA:
        motscles['GROUP_MA'] = GROUP_MA
    if MAILLE:
        motscles['MAILLE'] = MAILLE

    self.DeclareOut('ma2', MAILLAGE)
    ma2 = CREA_MAILLAGE(ECLA_PG=_F(MODELE=MODELE_INIT,  NOM_CHAM=NOM_CHAM,
                                   SHRINK=SHRINK, TAILLE_MIN=TAILLE_MIN, **motscles))

    # Appel à CREA_RESU :
    typ2 = AsType(RESU_INIT).__name__
    if TOUT_ORDRE:
        motscles['TOUT_ORDRE'] = TOUT_ORDRE
    if NUME_ORDRE != None:
        motscles['NUME_ORDRE'] = NUME_ORDRE
    if LIST_ORDRE:
        motscles['LIST_ORDRE'] = LIST_ORDRE
    if LIST_INST:
        motscles['LIST_INST'] = LIST_INST
    if INST != None:
        motscles['INST'] = INST

    self.DeclareOut('resu2', RESULTAT)
    resu2 = CREA_RESU(OPERATION='ECLA_PG', TYPE_RESU=string.upper(typ2),
                      ECLA_PG=_F(
                      MODELE_INIT=MODELE_INIT, RESU_INIT=RESU_INIT, NOM_CHAM=NOM_CHAM,
                                MAILLAGE=ma2, **motscles))
    return ier
#
