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

from ..Objects import Mesh
from .ExecuteCommand import ExecuteCommand


class MeshReader(ExecuteCommand):
    """Command that creates a :class:`~code_aster.Objects.Mesh` from a file."""
    command_name = "LIRE_MAILLAGE"


    def create_result(self, _):
        """Create the :class:`~code_aster.Objects.Mesh`.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Mesh.create()

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        mesh = self._result
        fileName = "fort.{UNITE}".format(**keywords)
        format = keywords["FORMAT"]
        if format == "MED":
            mesh.readMedFile( fileName )
        elif format == "GMSH":
            mesh.readGmshFile( fileName )
        elif format == "GIBI":
            mesh.readGibiFile( fileName )
        return mesh


LIRE_MAILLAGE = MeshReader.run
