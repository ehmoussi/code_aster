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
code_aster.init("--test")

test = code_aster.TestCase()

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMedFile("test001f.mmed")

# Definition du modele Aster
monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh(code_aster.Physics.Mechanics,
                              code_aster.Modelings.Tridimensional)

monModel.build()

charCine = code_aster.KinematicsMechanicalLoad()
charCine.setModel(monModel)
charCine.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dx,
                                           0., "Bas")
test.assertEqual( charCine.getType(), "CHAR_CINE_MECA" )

# Impossible d'affecter un blocage en temperature sur un DEPL
with test.assertRaises( RuntimeError ):
    charCine.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Temp,
                                               0., "Haut")

charCine.build()

code_aster.close()
