# coding: utf-8

# Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: nicolas.sellenet@edf.fr

from ..Objects import MaterialOnMesh
from ..Utilities import force_list
from .ExecuteCommand import ExecuteCommand


class MaterialAssignment(ExecuteCommand):
    """Assign the :class:`~code_aster.Objects.Material` properties on the
    :class:`~code_aster.Objects.Mesh` that creates a
    :class:`~code_aster.Objects.MaterialOnMesh` object.
    """
    command_name = "AFFE_MATERIAU"

    def create_result(self, keywords):
        """Initialize the :class:`~code_aster.Objects.Mesh`.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        mesh = None
        if keywords.has_key("MAILLAGE"):
            mesh = keywords["MAILLAGE"]
        else:
            mesh = keywords["MODELE"].getSupportMesh()
        self._result = MaterialOnMesh(mesh)

    def adapt_syntax(self, keywords):
        """Hook to adapt syntax from a old version or for compatibility reasons.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        for key in ("AFFE_COMPOR", "AFFE_VARC"):
            if keywords.get(key) != None:
                raise NotImplementedError("'{0}' is not yet implemented"
                                          .format(key))

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        fkw = keywords["AFFE"]
        if isinstance(fkw, dict):
            self._addMaterial(fkw)
        elif type(fkw) in (list, tuple):
            for curDict in fkw:
                self._addMaterial(curDict)
        else:
            raise TypeError("Unexpected type: {0!r} {1}".format(fkw, type(fkw)))

        self._result.build()

    def _addMaterial(self, fkw):
        kwTout = fkw.get("TOUT")
        kwGrMa = fkw.get("GROUP_MA")
        mater = fkw[ "MATER" ]

        for mater_i in mater:
            if kwTout != None:
                self._result.addMaterialOnAllMesh(mater_i)
            elif kwGrMa != None:
                kwGrMa = force_list(kwGrMa)
                for grp in kwGrMa:
                    self._result.addMaterialOnGroupOfElements(mater_i, grp)
            else:
                raise TypeError("At least {0} or {1} is required"
                                .format("TOUT", "GROUP_MA"))


AFFE_MATERIAU = MaterialAssignment.run
