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

from geomec_utils import *
from geomec_essais import *


def calc_essai_geomeca_ops(self, MATER, COMPORTEMENT, CONVERGENCE, INFO=None,
                           ESSAI_TD=None,
                           ESSAI_TND=None,
                           ESSAI_CISA_C=None,
                           ESSAI_TND_C=None,
                           ESSAI_TD_A=None,
                           ESSAI_TD_NA=None,
                           ESSAI_OEDO_C=None,
                           ESSAI_ISOT_C=None,
                           # ESSAI_XXX,
                           **args):
    """Corps de CALC_ESSAI_GEOMECA"""

    ier = 0

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # Verifs supplementaires des valeurs renseignees pr les MCF ESSAI_*
    verif_essais(COMPORTEMENT, ESSAI_TD,
                 ESSAI_TND,
                 ESSAI_CISA_C,
                 ESSAI_TND_C,
                 ESSAI_TD_A,
                 ESSAI_TD_NA,
                 ESSAI_OEDO_C,
                 ESSAI_ISOT_C,)
                           # ESSAI_XXX,)

    # ---
    # Essai 'TD'
    # ---
    if ESSAI_TD != None:

        for iocc, DicoEssai in enumerate(ESSAI_TD):
            str_num = int_2_str(iocc + 1, len(ESSAI_TD))
            essai_TD(self, str_num, DicoEssai,
                     MATER, COMPORTEMENT, CONVERGENCE, INFO)

    # ---
    # Essai 'TND'
    # ---
    if ESSAI_TND != None:

        for iocc, DicoEssai in enumerate(ESSAI_TND):
            str_num = int_2_str(iocc + 1, len(ESSAI_TND))
            essai_TND(self, str_num, DicoEssai,
                      MATER, COMPORTEMENT, CONVERGENCE, INFO)

    # ---
    # Essai 'CISA_C'
    # ---
    if ESSAI_CISA_C != None:

        for iocc, DicoEssai in enumerate(ESSAI_CISA_C):
            str_num = int_2_str(iocc + 1, len(ESSAI_CISA_C))
            essai_CISA_C(self, str_num, DicoEssai,
                         MATER, COMPORTEMENT, CONVERGENCE, INFO)

    # ---
    # Essai 'TND_C'
    # ---
    if ESSAI_TND_C != None:

        for iocc, DicoEssai in enumerate(ESSAI_TND_C):
            str_num = int_2_str(iocc + 1, len(ESSAI_TND_C))
            essai_TND_C(self, str_num, DicoEssai,
                        MATER, COMPORTEMENT, CONVERGENCE, INFO)

    # ---
    # Essai 'TD_A'
    # ---
    if ESSAI_TD_A != None:

        for iocc, DicoEssai in enumerate(ESSAI_TD_A):
            str_num = int_2_str(iocc + 1, len(ESSAI_TD_A))
            essai_TD_A(self, str_num, DicoEssai,
                       MATER, COMPORTEMENT, CONVERGENCE, INFO)

    # ---
    # Essai 'TD_NA'
    # ---
    if ESSAI_TD_NA != None:

        for iocc, DicoEssai in enumerate(ESSAI_TD_NA):
            str_num = int_2_str(iocc + 1, len(ESSAI_TD_NA))
            essai_TD_NA(self, str_num, DicoEssai,
                        MATER, COMPORTEMENT, CONVERGENCE, INFO)

    # ---
    # Essai 'OEDO_C'
    # ---
    if ESSAI_OEDO_C != None:

        for iocc, DicoEssai in enumerate(ESSAI_OEDO_C):
            str_num = int_2_str(iocc + 1, len(ESSAI_OEDO_C))
            essai_OEDO_C(self, str_num, DicoEssai,
                         MATER, COMPORTEMENT, CONVERGENCE, INFO)

    # ---
    # Essai 'ISOT_C'
    # ---
    if ESSAI_ISOT_C != None:

        for iocc, DicoEssai in enumerate(ESSAI_ISOT_C):
            str_num = int_2_str(iocc + 1, len(ESSAI_ISOT_C))
            essai_ISOT_C(self, str_num, DicoEssai,
                         MATER, COMPORTEMENT, CONVERGENCE, INFO)

    # ---
    # Essai 'XXX'
    # ---
    # if ESSAI_XXX != None : ...
    return
