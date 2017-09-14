#!/usr/bin/python

# coding: utf-8

# Cas-test issu de sdlv134a
# Validation de la sous-structuration cyclique

import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

secteur = code_aster.Mesh.create()
secteur.readMedFile("sdlv134a.mmed")

modele = code_aster.Model.create()
modele.setSupportMesh(secteur)
modele.addModelingOnAllMesh(code_aster.Physics.Mechanics,
                           code_aster.Modelings.Tridimensional)
modele.build()

Young = 2.E11
Poisson = 0.3
Rho = 7800.0

materElas = code_aster.ElasMaterialBehaviour.create()
materElas.setDoubleValue("E", Young)
materElas.setDoubleValue("Nu", Poisson)
materElas.setDoubleValue("Rho", Rho)

acier = code_aster.Material.create()
acier.addMaterialBehaviour(materElas)
acier.build()

affeMat = code_aster.MaterialOnMesh.create(secteur)
affeMat.addMaterialOnAllMesh(acier)
affeMat.build()

charCine = code_aster.KinematicsLoad.create()
charCine.setSupportModel(modele)
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx, 
                                        0., ["ENCAS","AXE","Droite","Gauche"])
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dy, 
                                        0., ["ENCAS","AXE","Droite","Gauche"])
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dz, 
                                        0., ["ENCAS","AXE","Droite","Gauche"])
charCine.build()

study = code_aster.StudyDescription.create(modele, affeMat)
dProblem = code_aster.DiscreteProblem.create(study)
rigiElem = dProblem.computeMechanicalRigidityMatrix()
massElem = dProblem.computeMechanicalMassMatrix()

numeDDL = code_aster.DOFNumbering.create()
numeDDL.setElementaryMatrix(rigiElem)
numeDDL.computeNumerotation()

rigiAsse = code_aster.AssemblyMatrixDouble.create()
rigiAsse.setElementaryMatrix(rigiElem)
rigiAsse.setDOFNumbering(numeDDL)
rigiAsse.addKinematicsLoad(charCine)
rigiAsse.build()

massAsse = code_aster.AssemblyMatrixDouble.create()
massAsse.setElementaryMatrix(massElem)
massAsse.setDOFNumbering(numeDDL)
massAsse.addKinematicsLoad(charCine)
massAsse.build()

structInterf = code_aster.StructureInterface.create()
structInterf.addInterface( "axe_interf", code_aster.InterfaceType.CraigBampton,
                       ["AXE"] )
structInterf.addInterface( "droite_interf", code_aster.InterfaceType.CraigBampton,
                       ["Droite"] )
structInterf.addInterface( "Gauche_interf", code_aster.InterfaceType.CraigBampton,
                       ["Gauche"] )
#structInterf.build()

