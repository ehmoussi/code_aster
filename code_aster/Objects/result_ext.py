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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`Result` --- Results container
**************************************************
"""

import aster
from libaster import MaterialOnMesh, Model, Result

from ..Utilities import injector
from .datastructure_ext import get_depends, set_depends


@injector(Result)
class ExtendedResult(object):
    cata_sdj = "SD.sd_resultat.sd_resultat"

    def __getstate__(self):
        """Return internal state.

        Returns:
            list: Internal state.
        """
        models = []
        materials = []
        ranks = self.getRanks()
        for i in ranks:
            try:
                models.append(self.getModel(i))
            except:
                pass
            try:
                materials.append(self.getMaterialOnMesh(i))
            except:
                pass
        if len(ranks) != len(models):
            models = []
        if len(ranks) != len(materials):
            materials = []
        state = get_depends(self)
        state.append(len(ranks))
        state.extend(ranks)
        state.append(len(models))
        state.extend(models)
        state.append(len(materials))
        state.extend(materials)
        return state

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (list): Internal state.
        """
        set_depends(self, state)
        nbranks = state.pop(0)
        ranks = []
        for _ in range(nbranks):
            ranks.append(state.pop(0))
        nbmod = state.pop(0)
        for i in range(nbmod):
            self.addModel(state.pop(0), ranks[i])
        nbmat = state.pop(0)
        for i in range(nbmat):
            self.addMaterialOnMesh(state.pop(0), ranks[i])

    def LIST_CHAMPS (self) :
        return aster.GetResu(self.getName(), "CHAMPS")

    def LIST_VARI_ACCES (self):
        return aster.GetResu(self.getName(), "VARI_ACCES")

    def LIST_PARA (self):
        return aster.GetResu(self.getName(), "PARAMETRES")
