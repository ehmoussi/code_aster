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
:py:class:`MaterialOnMesh` --- Assignment of material properties on mesh
************************************************************************
"""

import aster
from libaster import MaterialOnMesh
from libaster import EntityType

from ..Utilities import injector


class ExtendedMaterialOnMesh(injector(MaterialOnMesh), MaterialOnMesh):
    cata_sdj = "SD.sd_cham_mater.sd_cham_mater"

    def __getinitargs__(self):
        """Returns the argument required to reinitialize a MaterialOnMesh
        object during unpickling.
        """
        return (self.getName(), self.getSupportMesh())

    def __getstate__(self):
        """Return internal state.

        Returns:
            dict: Internal state.
        """
        vecOfPartOfMaterialOnMesh = self.getVectorOfPartOfMaterialOnMesh()
        state = ()
        for part in self.getVectorOfPartOfMaterialOnMesh():
            vecOfMater = part.getVectorOfMaterial()
            partState = (len(vecOfMater),) + tuple(vecOfMater)
            names = part.getMeshEntity().getNames()
            type = part.getMeshEntity().getType()
            if type is EntityType.AllMeshEntitiesType:
                partState = partState + (0, names, )
            elif type is EntityType.GroupOfElementsType:
                partState = partState + (1, names, )
            elif type is EntityType.ElementType:
                partState = partState + (2, names, )
            else:
                assert False
            state = state + partState
        return state

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (dict): Internal state.
        """
        if state is not ():
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
                        type = EntityType.GroupOfElementsType
                    elif state[i] == 2:
                        type = EntityType.ElementType
                    else:
                        assert False
                if i == endMater + 2:
                    names =  state[i]
                    if type is EntityType.AllMeshEntitiesType:
                        self.addMaterialsOnAllMesh(listOfMater)
                    elif type is EntityType.GroupOfElementsType:
                        self.addMaterialsOnAllMesh(listOfMater, names)
                    elif type is EntityType.ElementType:
                        self.addMaterialsOnAllMesh(listOfMater, names)
                    searchForSize = True
                    endMater = 0
                    listOfMater = []
                    type = -1
