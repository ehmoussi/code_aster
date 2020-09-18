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
from code_aster.Commands import *

code_aster.init("--test")

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("xxContact001a.mmed")

MO2 = code_aster.Model(MA)
MO2.addModelingOnMesh(code_aster.Physics.Acoustic, code_aster.Modelings.Tridimensional)
MO2.build()

load = code_aster.AcousticLoad(MO2)
load.addImposedPressureOnGroupOfCells( ["FONDATION"], 1.+2.j )
load.addImposedNormalSpeedOnGroupOfCells( ["FONDATION"], 3.+4.j )
load.addImpedanceOnMesh( 5.+6.j )
load.build()
load.debugPrint(8)

# Test trivial
test.assertTrue( True )

FIN()
