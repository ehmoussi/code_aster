#!/usr/bin/python

import code_aster
test = code_aster.TestCase()

# @@@@

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMedFile("test001f.mmed")

# Definition du modele Aster
monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelingOnAllMesh(code_aster.Thermal, code_aster.Tridimensional)
monModel.build()

# @@@@

CHA = code_aster.Loads.ThermalLoad()
CHA.setModel(monModel)

a = code_aster.Loads.DoubleImposedTemperature(456.0)
a.addGroupOfNodes("test_node")
CHA.addUnitaryThermalLoad(a)

b = code_aster.Loads.DoubleDistributedFlow(999.5)
b.setNormalFlow(555.5)
b.setLowerNormalFlow(-101.0)
b.setUpperNormalFlow(+101.0)
b.setFlowXYZ(25.0, 35.0, 45.0)
b.addGroupOfElements("test_element")
CHA.addUnitaryThermalLoad(b)
# b.debugPrint(8)

# addElementaryThermalLoad


bb = code_aster.Loads.DoubleNonLinearFlow(999.5)
bb.setFlow(111.5)
bb.addGroupOfElements("test_fluxnl_element")
CHA.addUnitaryThermalLoad(bb)

c = code_aster.Loads.DoubleExchange(25.0)
c.setExternalTemperature(333.55)
c.setExchangeCoefficient(134.56)
c.setExternalTemperatureInfSup(120.0, 230.0)
c.addGroupOfElements("test_echange_element")
CHA.addUnitaryThermalLoad(c)

cc = code_aster.Loads.DoubleExchangeWall(50.0)
cc.setTranslation([11.0, 22.0, 33.0])
cc.setExchangeCoefficient(789.01)
cc.addGroupOfElements("test_echange_paroi_element")
CHA.addUnitaryThermalLoad(cc)

d = code_aster.Loads.DoubleThermalRadiation()
d.setExternalTemperature(555.0)
d.setEpsilon(1.E-5)
d.setSigma(33.3)
CHA.addUnitaryThermalLoad(d)

e = code_aster.Loads.DoubleThermalGradient()
e.setFlowXYZ(111.0, 222.0, 333.0)
CHA.addUnitaryThermalLoad(e)

# help(CHA)

# at least it pass here!
test.assertTrue( True )
test.printSummary()
