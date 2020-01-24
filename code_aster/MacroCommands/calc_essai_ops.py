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

"""
Implémentation de la macro CALC_ESSAI

Ce module contient la partie controle de la macro CALC_ESSAI
"""

import inspect

from libaster import onFatalError

from .CalcEssai.cata_ce import CalcEssaiObjects
from .CalcEssai.ce_test import MessageBox, TestCalcEssai


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
    caller = inspect.currentframe()
    # 1: exec_, 2: run_, 3: run, 4: user
    for _ in range(4):
        caller = caller.f_back
        context = caller.f_globals

    prev = onFatalError()

    # gestion des concepts sortants de la macro, declares a priori
    table_fonction = []
    if RESU_IDENTIFICATION:
        for res in RESU_IDENTIFICATION:
            table_fonction.append(res['TABLE'])
    out_identification = {"Register": self.register_result,
                          "TypeTables": 'TABLE_FONCTION',
                          "ComptTable": 0,
                          "TablesOut": table_fonction}

    out_modifstru = RESU_MODIFSTRU or {}

    mess = MessageBox(UNITE_RESU)

    objects = CalcEssaiObjects(mess)
    objects.recup_objects(context)

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
    onFatalError(prev)
