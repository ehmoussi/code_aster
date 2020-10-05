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
# ----------------------------------- ---------------------------------

# person_in_charge: nicolas.pignet at edf.fr

from mpi4py import MPI

from .myMEDSplitter_mpi import BuildPartNameFromOrig, MakeThePartition, GetGraphPartitioner, setVerbose


class MEDPartitioner:

    """This class allows to read, partitioning and write a MED mesh in parallel

    """

    def __init__(self, filename, meshname=None):
        """Initialization
        :param filename: name of MED file
        :type filename: string
        :param meshname: name of mesh
        :type meshname: string
        """
        self._filename = filename
        self._meshname = meshname
        self._meshPartitioned = None
        self._writedFilename = None

    def filename(self):
        """ Return the name of MED file"""
        return self._filename

    def writedFilename(self):
        """ Return the name of the writed MED file"""
        return self._writedFilename

    def meshname(self):
        """ Return the name of the mesh"""
        return self.meshname

    def getPartition(self):
        """ Return the partition of the mesh"""
        return self._meshPartitioned

    def partitionMesh(self, verbose=False):
        """ Partition the mesh

        Arguments:
            verbose = False (bool): active verbosity mode
        """
        if verbose:
            setVerbose(2)

        self._meshPartitioned = MakeThePartition(self._filename, self._meshname, GetGraphPartitioner(None))

        if verbose:
            setVerbose(0)

    def writeMesh(self, path=None):
        """ Write the partitioning mesh file in MED format

         Arguments:
            path (str): path where to write the file
        """
        full_path = self.filename()
        if (path is not None):
            if path.endswith("/"):
                full_path = path + self.filename()
            else:
                full_path = path + "/" + self.filename()

        self._writedFilename = BuildPartNameFromOrig(full_path, MPI.COMM_WORLD.rank)

        if self._meshPartitioned is not None:
            self._meshPartitioned.write33( self.writedFilename(), 2)
