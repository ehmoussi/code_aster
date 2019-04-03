# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
:py:class:`ResultsContainer` --- Results container
**************************************************
"""

import aster
from libaster import ResultsContainer, Model, MaterialOnMesh

from ..Utilities import injector


@injector(ResultsContainer)
class ExtendedResultsContainer(object):
    cata_sdj = "SD.sd_resultat.sd_resultat"

    def __getstate__(self):
        """Return internal state.

        Returns:
            dict: Internal state.
        """
        models = []
        materials = []
        ranks = self.getRanks()
        for i in ranks:
            try:
                models.append(self.getModel(i))
            except: pass
            try:
                materials.append(self.getMaterialOnMesh(i))
            except: pass
        if len(ranks) != len(models):
            models = []
        if len(ranks) != len(materials):
            materials = []
        tupleOut = tuple(ranks) + tuple(models) + tuple(materials)
        return tupleOut

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (dict): Internal state.
        """
        ranks = []
        rankModel = 0
        rankMater = 0
        for obj in state:
            if type(obj) == int:
                ranks.append(obj)
            if isinstance(obj, Model):
                self.addModel(obj, ranks[rankModel])
                rankModel = rankModel + 1
            if isinstance(obj, MaterialOnMesh):
                self.addMaterialOnMesh(obj, ranks[rankMater])
                rankMater = rankMater + 1

    def LIST_CHAMPS (self) :
        if not self.accessible():
            raise AsException("Erreur dans resultat.LIST_CHAMPS en PAR_LOT='OUI'")
        return aster.GetResu(self.get_name(), "CHAMPS")

    def LIST_VARI_ACCES (self):
        if not self.accessible():
            raise AsException("Erreur dans resultat.LIST_VARI_ACCES " +
                              "en PAR_LOT='OUI'")
        return aster.GetResu(self.get_name(), "VARI_ACCES")

    def LIST_PARA (self):
        if not self.accessible():
            raise AsException("Erreur dans resultat.LIST_PARA en PAR_LOT='OUI'")
        return aster.GetResu(self.get_name(), "PARAMETRES")
