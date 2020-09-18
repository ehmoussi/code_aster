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

# @@@@

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMedFile("test001f.mmed")

# Definition du modele Aster
monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh(code_aster.Physics.Thermal, code_aster.Modelings.Tridimensional)
monModel.build()

# @@@@

CHA = code_aster.ThermalLoad(monModel)
test.assertEqual(CHA.getType(),"CHAR_THER")

a = code_aster.RealImposedTemperature(456.0)
a.addGroupOfNodes("test_node")
CHA.addUnitaryThermalLoad(a)

b = code_aster.RealDistributedFlow(999.5)
b.setNormalFlow(555.5)
b.setLowerNormalFlow(-101.0)
b.setUpperNormalFlow(+101.0)
b.setFlowXYZ(25.0, 35.0, 45.0)
b.addGroupOfCells("test_element")
CHA.addUnitaryThermalLoad(b)
# b.debugPrint(8)

# addElementaryThermalLoad


bb = code_aster.RealNonLinearFlow(999.5)
bb.setFlow(111.5)
bb.addGroupOfCells("test_fluxnl_element")
CHA.addUnitaryThermalLoad(bb)

c = code_aster.RealExchange(25.0)
c.setExternalTemperature(333.55)
c.setExchangeCoefficient(134.56)
c.setExternalTemperatureInfSup(120.0, 230.0)
c.addGroupOfCells("test_echange_element")
CHA.addUnitaryThermalLoad(c)

cc = code_aster.RealExchangeWall(50.0)
cc.setTranslation([11.0, 22.0, 33.0])
cc.setExchangeCoefficient(789.01)
cc.addGroupOfCells("test_echange_paroi_element")
CHA.addUnitaryThermalLoad(cc)

d = code_aster.RealThermalRadiation()
d.setExternalTemperature(555.0)
d.setEpsilon(1.E-5)
d.setSigma(33.3)
CHA.addUnitaryThermalLoad(d)

e = code_aster.RealThermalGradient()
e.setFlowXYZ(111.0, 222.0, 333.0)
CHA.addUnitaryThermalLoad(e)

# help(CHA)

# at least it pass here!
test.printSummary()

FIN()
