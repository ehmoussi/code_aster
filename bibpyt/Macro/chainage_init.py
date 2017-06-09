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

import aster
from code_aster.Cata.Syntax import _F


def CHAINAGE_INIT(self, args, motscles):

    MODELE_MECA = args['MODELE_MECA']
    MODELE_HYDR = args['MODELE_HYDR']

    # On importe les definitions des commandes a utiliser dans la macro
    CREA_MAILLAGE = self.get_cmd('CREA_MAILLAGE')
    PROJ_CHAMP = self.get_cmd('PROJ_CHAMP')

    MATR_MH = PROJ_CHAMP(METHODE='COLLOCATION', MODELE_1=MODELE_MECA,
                         MODELE_2=MODELE_HYDR, PROJECTION='NON', **motscles)

    iret, ibid, nom_mail = aster.dismoi(
        'NOM_MAILLA', MODELE_HYDR.nom, 'MODELE', 'F')
    nom_mail = nom_mail.strip()
    __maillage_h = self.get_concept(nom_mail)

    _maillin = CREA_MAILLAGE(MAILLAGE=__maillage_h,
                             QUAD_LINE=_F(TOUT='OUI',), **motscles)

    MATR_HM1 = PROJ_CHAMP(METHODE='COLLOCATION',  MODELE_1=MODELE_HYDR,
                          MAILLAGE_2=_maillin, PROJECTION='NON', **motscles)
    MATR_HM2 = PROJ_CHAMP(METHODE='COLLOCATION',  MAILLAGE_1=_maillin,
                          MODELE_2=MODELE_MECA, PROJECTION='NON', **motscles)

    return MATR_MH, MATR_HM1, MATR_HM2
