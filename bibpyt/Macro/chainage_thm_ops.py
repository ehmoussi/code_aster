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

#
#
# On pourrait éventuellement utiliser MACR_ADAP_MAIL dans
# cette macro pour gagner du temps sur
# la phase de projection ...
# Serait utile surtout pour le 3D et pour les gros
# maillages
#
#

import aster
import numpy
from code_aster.Cata.Syntax import _F
from Utilitai.Utmess import UTMESS
from .chainage_init import *
from .chainage_hydr_meca import *
from .chainage_meca_hydr import *


def chainage_thm_ops(self, TYPE_CHAINAGE, **args):
    """
       Ecriture de la macro CHAINAGE_THM
    """
    #
    # RESU_MECA / MODELE_HYDR : résultat mécanique à projeter
    #                           modèle hydraulique d'arrivée
    # RESU_HYDR / MODELE_MECA : résultat hydraulique à projeter
    #                           modèle mécanique d'arrivée
    # INST                    : instant auquel on veut les variables de commande
    # MATR_MH / MATR_HM1 / MATR_HM2 : matrices de projection pour gagner
    #                                 du temps sur les phases de projection
    # TYPE_CHAINAGE   : MECA_HYDR / HYDR_MECA / INIT
    # TYPE_RESU       : obligatoire si TYPE_CHAINAGE = HYDR_MECA
    #                   -> evol_varc
    #                   -> cham_no
    #

    #
    # Début de la macro-commande
    #
    #
    # 3 possibilités pour TYPE_CHAINAGE :
    #  1. HYDR_MECA
    #  2. MECA_HYDR
    #  3. INIT
    #
    #
    # 1. Chaînage HYDRAULIQUE ===> MECANIQUE
    #

    motscles = dict()

    if (TYPE_CHAINAGE == "HYDR_MECA"):
        return CHAINAGE_HYDR_MECA(self, args, motscles)

    #
    # 2. Chaînage MECANIQUE ===> HYDRAULIQUE
    #

    elif (TYPE_CHAINAGE == "MECA_HYDR"):
        return CHAINAGE_MECA_HYDR(self, args, motscles)

    #
    # 3. Initialisation des matrices de projection
    #

    elif (TYPE_CHAINAGE == "INIT"):
        MATR_MH, MATR_HM1, MATR_HM2 = CHAINAGE_INIT(self, args, motscles)
        self.register_result(MATR_MH, args['MATR_MH'])
        self.register_result(MATR_HM1, args['MATR_HM1'])
        self.register_result(MATR_HM2, args['MATR_HM2'])

    else:
        UTMESS('F', 'DVP_1')

    return
