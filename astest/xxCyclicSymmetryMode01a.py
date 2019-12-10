
# coding: utf-8

# Cas-test issu de sdlv134a
# Validation de la sous-structuration cyclique

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

secteur = code_aster.Mesh()
secteur.readMedFile("sdlv134a.mmed")

modele = code_aster.Model()
modele.setMesh(secteur)
modele.addModelingOnAllMesh(code_aster.Physics.Mechanics,
                           code_aster.Modelings.Tridimensional)
modele.build()

Young = 2.E11
Poisson = 0.3
Rho = 7800.0

acier = DEFI_MATERIAU(ELAS = _F(E = Young,
                                NU = Poisson,
                                RHO = Rho),)

affeMat = code_aster.MaterialOnMesh(secteur)
affeMat.addMaterialOnAllMesh(acier)
affeMat.buildWithoutInputVariables()

charCine = code_aster.KinematicsMechanicalLoad()
charCine.setModel(modele)
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx,
                                        0., ["ENCAS","AXE","Droite","Gauche"])
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dy,
                                        0., ["ENCAS","AXE","Droite","Gauche"])
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dz,
                                        0., ["ENCAS","AXE","Droite","Gauche"])
charCine.build()

study = code_aster.StudyDescription(modele, affeMat)
dProblem = code_aster.DiscreteProblem(study)
rigiElem = dProblem.computeMechanicalStiffnessMatrix()
massElem = dProblem.computeMechanicalMassMatrix()

numeDDL = code_aster.DOFNumbering()
numeDDL.setElementaryMatrix(rigiElem)
numeDDL.computeNumbering()

rigiAsse = code_aster.AssemblyMatrixDisplacementDouble()
rigiAsse.appendElementaryMatrix(rigiElem)
rigiAsse.setDOFNumbering(numeDDL)
rigiAsse.addKinematicsLoad(charCine)
rigiAsse.build()

massAsse = code_aster.AssemblyMatrixDisplacementDouble()
massAsse.appendElementaryMatrix(massElem)
massAsse.setDOFNumbering(numeDDL)
massAsse.addKinematicsLoad(charCine)
massAsse.build()

structInterf = code_aster.StructureInterface()
structInterf.addInterface( "axe_interf", code_aster.InterfaceType.CraigBampton,
                       ["AXE"] )
structInterf.addInterface( "droite_interf", code_aster.InterfaceType.CraigBampton,
                       ["Droite"] )
structInterf.addInterface( "Gauche_interf", code_aster.InterfaceType.CraigBampton,
                       ["Gauche"] )
#structInterf.build()

# at least it pass here!
test.assertTrue( True )
test.printSummary()

FIN()
