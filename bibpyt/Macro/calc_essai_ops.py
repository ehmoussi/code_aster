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

# \package calc_essai_ops Implémentation de la macro CALC_ESSAI
#
# Ce module contient la partie controle de la macro CALC_ESSAI
# les autres fichiers sources sont situes dans ../Calc_essai


def calc_essai_ops(self,
                   UNITE_RESU=None,
                   EXPANSION=None,
                   IDENTIFICATION=None,
                   MODIFSTRUCT=None,
                   TRAITEMENTSIG=None,
                   GROUP_NO_CAPTEURS=None,
                   GROUP_NO_EXTERIEUR=None,
                   RESU_IDENTIFICATION=None,
                   RESU_MODIFSTRU=None,
                   **args):

    from Calc_essai.cata_ce import CalcEssaiObjects
    from Calc_essai.ce_test import MessageBox
    from Calc_essai.ce_test import TestCalcEssai
    import aster
    ier = 0

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    prev = aster.onFatalError()

    # gestion des concepts sortants de la macro, declares a priori
    table_fonction = []

    if not RESU_MODIFSTRU:
        out_modifstru = {}
    else:
        out_modifstru = RESU_MODIFSTRU[0]  # max=1 dans le capy

    if not RESU_IDENTIFICATION:
        RESU_IDENTIFICATION = []
    else:
        for res in RESU_IDENTIFICATION:
            table_fonction.append(res['TABLE'])
    out_identification = {"DeclareOut": self.DeclareOut,
                          "TypeTables": 'TABLE_FONCTION',
                          "ComptTable": 0,
                          "TablesOut": table_fonction}


    mess = MessageBox(UNITE_RESU)

    objects = CalcEssaiObjects(self, mess)

    # importation des concepts aster existants de la memoire jeveux
    TestCalcEssai(  self,
                    mess,
                    out_identification,
                    out_modifstru,
                    objects,
                    EXPANSION,
                    IDENTIFICATION,
                    MODIFSTRUCT,
                    GROUP_NO_CAPTEURS,
                    GROUP_NO_EXTERIEUR
                )

    mess.close_file()
    aster.onFatalError(prev)
    return ier
