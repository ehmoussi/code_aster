# coding: utf-8

# Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
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

from ..Cata.Commands.lire_maillage import keywords as main_keywords
from ..Cata.DataStructure import maillage_sdaster
from ..Cata.Syntax import OPER, SIMP, tr
from ..Helpers import LogicalUnitFile
from ..Objects import Mesh, ParallelMesh
from ..Supervis import ExecuteCommand
from ..Messages import UTMESS
from .pre_gibi import PRE_GIBI
from .pre_gmsh import PRE_GMSH
from .pre_ideas import PRE_IDEAS

from libaster import getMPINumberOfProcs


class MeshReader(ExecuteCommand):
    """Command that creates a :class:`~code_aster.Objects.Mesh` from a file."""
    command_name = "LIRE_MAILLAGE"

    def _create_parallel_mesh(self, keywords):
        """Tell if the command is creating a ParallelMesh

        Arguments:
            keywords (dict): User's keywords.

        Returns:
            bool: *True* if a ParallelMesh is creating, *False* otherwise.
        """
        return (keywords['FORMAT'] == "MED" and
                keywords['PARTITIONNEUR'] == "PTSCOTCH" and
                getMPINumberOfProcs() > 1)

    def create_result(self, keywords):
        """Create the :class:`~code_aster.Objects.Mesh`.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if self._create_parallel_mesh(keywords):
            self._result = ParallelMesh()
        else:
            self._result = Mesh()

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        need_conversion = ('GIBI', 'GMSH', 'IDEAS')
        unit = keywords.get('UNITE')
        fmt = keywords['FORMAT']

        if fmt in need_conversion:
            tmpfile = LogicalUnitFile.new_free(new=True)
            unit_op = tmpfile.unit
            keywords['FORMAT'] = 'ASTER'
        else:
            unit_op = unit


        if fmt == 'GIBI':
            PRE_GIBI(UNITE_GIBI=unit, UNITE_MAILLAGE=unit_op)
        elif fmt == 'GMSH':
            PRE_GMSH(UNITE_GMSH=unit, UNITE_MAILLAGE=unit_op)
        elif fmt == 'IDEAS':
            coul = keywords.pop('CREA_GROUP_COUL', 'NON')
            PRE_IDEAS(UNITE_IDEAS=unit, UNITE_MAILLAGE=unit_op,
                      CREA_GROUP_COUL=coul)

        if self._result.isParallel():
            filename = LogicalUnitFile.filename_from_unit(unit)
            self._result.readMedFile(filename, partitioned=False, verbose=keywords['INFO_MED']-1)
        else:
            if keywords['FORMAT'] == "MED" and keywords['PARTITIONNEUR'] == "PTSCOTCH":
                assert getMPINumberOfProcs() == 1
                UTMESS("A", "MED_18")

            if fmt in need_conversion:
                tmpfile.release()

            keywords['UNITE'] = unit_op

            super(MeshReader, self).exec_(keywords)

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.update()


LIRE_MAILLAGE = MeshReader.run
