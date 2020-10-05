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

# person_in_charge: nicolas.pignet@edf.fr
"""
:py:class:`ParallelMesh` --- Assignment of parallel mesh
************************************************************************
"""

from libaster import ParallelMesh

from ..Utilities import injector
from ..Utilities.MEDPartitioner import MEDPartitioner


@injector(ParallelMesh)
class ExtendedParallelMesh(object):

    def readMedFile(self, filename, partitioned=False, verbose=False) :
        """Read a MED file containing a mesh and eventually partition it

        Arguments:
            filename (string): name of the MED file
            partitioned (bool) : False if the mesh is not yet partitioned and have to
            be partitioned before readinf
            verbose (bool) : Active verbosity mode

        Returns:
            bool: True if reading and partionning is ok
        """

        if partitioned:
            filename_partitioned = filename
        else:
            ms = MEDPartitioner(filename)
            ms.partitionMesh(verbose)
            ms.writeMesh()
            filename_partitioned = ms.writedFilename()

        return self._readPartitionedMedFile(filename_partitioned)
