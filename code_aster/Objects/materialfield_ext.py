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
:py:class:`MaterialField` --- Assignment of material properties on mesh
************************************************************************
"""

import aster
from libaster import EntityType, MaterialField

from ..Utilities import injector
from .datastructure_ext import get_depends, set_depends


@injector(MaterialField)
class ExtendedMaterialField(object):
    cata_sdj = "SD.sd_cham_mater.sd_cham_mater"

    def __getinitargs__(self):
        """Returns the argument required to reinitialize a MaterialField
        object during unpickling.
        """
        return (self.getName(), self.getMesh())

    def __getstate__(self):
        """Return internal state.

        Returns:
            list: Internal state.
        """
        state = get_depends(self)
        for part in self.getVectorOfPartOfMaterialField():
            vecOfMater = part.getVectorOfMaterial()
            partState = [len(vecOfMater)]
            partState.extend(vecOfMater)
            names = part.getMeshEntity().getNames()
            type = part.getMeshEntity().getType()
            if type is EntityType.AllMeshEntitiesType:
                partState.extend([0, names])
            elif type is EntityType.GroupOfCellsType:
                partState.extend([1, names])
            elif type is EntityType.CellType:
                partState.extend([2, names])
            else:
                assert False
            state.extend(partState)
        return state

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (list): Internal state.
        """
        set_depends(self, state)
        if state:
            nbMater = len(state)

            searchForSize = True
            endMater = 0
            listOfMater = []
            type = -1
            for i in range(nbMater):
                if i <= endMater and not searchForSize:
                    listOfMater.append(state[i])
                if searchForSize:
                    endMater = i + state[i]
                    searchForSize = False
                if i == endMater + 1:
                    if state[i] == 0:
                        type = EntityType.AllMeshEntitiesType
                    elif state[i] == 1:
                        type = EntityType.GroupOfCellsType
                    elif state[i] == 2:
                        type = EntityType.CellType
                    else:
                        assert False
                if i == endMater + 2:
                    names =  state[i]
                    if type is EntityType.AllMeshEntitiesType:
                        self.addMaterialsOnMesh(listOfMater)
                    elif type is EntityType.GroupOfCellsType:
                        self.addMaterialsOnGroupOfCells(listOfMater, names)
                    elif type is EntityType.CellType:
                        self.addMaterialsOnCell(listOfMater, names)
                    searchForSize = True
                    endMater = 0
                    listOfMater = []
                    type = -1
