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

import code_aster

import medcoupling as mc
from mpi4py import MPI

code_aster.init("--test")

test = code_aster.TestCase()

rank = code_aster.getMPIRank()
nbproc = code_aster.getMPINumberOfProcs()

if nbproc > 1:
    is_parallel = True
else:
    is_parallel = False

name_file = ["mesh002s.30", "mesh002t.30", "mesh002u.30"]

# list of mesh to partition
list_mesh = open(name_file[nbproc-2], 'r')

nb_mesh = 0
nb_mesh_converted = 0
# loop on mesh
for line in list_mesh :
    nb_mesh += 1
    mesh_name = line.rstrip("\n").strip()
    if not mesh_name.startswith("#"):
        mesh_vers = mc.MEDFileVersionOfFileStr(mesh_name)
        vers_num = int(mesh_vers.replace(".", ""))

        print("MESHAME %d: %s (version: %s)"%(nb_mesh, mesh_name, mesh_vers), flush=True)

        # convert old med mesh < 3.0.0
        if vers_num < 300:
            mfd = mc.MEDFileData(mesh_name)
            mesh_name=mesh_name.split(".")[0]+"_tmp.med"
            mfd.write(mesh_name,2)
            print("Mesh converted: %s (version: %s)"%(mesh_name, mc.MEDFileVersionOfFileStr(mesh_name)), flush=True)

        # read parallel mesh and partitioning
        MPI.COMM_WORLD.barrier()
        pmesh = code_aster.ParallelMesh()
        pmesh.readMedFile(mesh_name)
        test.assertTrue(pmesh.getNumberOfNodes()>0)
        test.assertTrue(pmesh.getNumberOfCells()>0)
        nb_mesh_converted += 1

list_mesh.close()

list_nb_mesh = [510,496,485]
list_nb_mesh_conv = [510,496,485]

print("Number of mesh: %s"%(nb_mesh), flush=True)
print("Number of mesh converted: %s"%(nb_mesh_converted), flush=True)

# all the mesh are partitioned
test.assertTrue(is_parallel)
test.assertEqual(nb_mesh, list_nb_mesh[nbproc-2])
test.assertEqual(nb_mesh_converted, list_nb_mesh_conv[nbproc-2])


test.printSummary()


code_aster.close()
