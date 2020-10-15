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

import gc

import code_aster
from code_aster.Commands import *
import libaster

code_aster.init("--test")
test = code_aster.TestCase()

def tco(obj):
    """Return TCO object name"""
    return "{0:19s}._TCO".format(obj.getName())

# mesh
mesh = LIRE_MAILLAGE(UNITE=20, FORMAT='MED')
tc0 = tco(mesh)
test.assertTrue(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)

# del mesh
# gc.collect()
DETRUIRE(CONCEPT=_F(NOM=mesh))
test.assertFalse(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)

# mesh < model
mesh = LIRE_MAILLAGE(UNITE=20, FORMAT='MED')
tc0 = tco(mesh)
test.assertTrue(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)

model = AFFE_MODELE(MAILLAGE=(mesh, ),
                    AFFE=_F(TOUT='OUI',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='3D'))
tc1 = tco(model)
test.assertTrue(libaster.debugJeveuxExists(tc1), msg="model / " + tc1)

# del mesh
# gc.collect()
DETRUIRE(CONCEPT=_F(NOM=mesh))
test.assertTrue(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)

# del model
# gc.collect()
DETRUIRE(CONCEPT=_F(NOM=model))
test.assertFalse(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)
test.assertFalse(libaster.debugJeveuxExists(tc1), msg="model / " + tc1)

# mesh < model, material < fieldmat
mesh = LIRE_MAILLAGE(UNITE=20, FORMAT='MED')
tc0 = tco(mesh)
test.assertTrue(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)

model = AFFE_MODELE(MAILLAGE=(mesh, ),
                    AFFE=_F(TOUT='OUI',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='3D'))
tc1 = tco(model)
test.assertTrue(libaster.debugJeveuxExists(tc1), msg="model / " + tc1)

material = DEFI_MATERIAU(ELAS=_F(E=2000,
                                 NU=0.3))
tc2 = tco(material)
test.assertTrue(libaster.debugJeveuxExists(tc2), msg="material / " + tc2)

fieldmat = AFFE_MATERIAU(MAILLAGE=mesh,
                         MODELE=model,
                         AFFE=_F(TOUT='OUI',
                                 MATER=material))
tc3 = tco(fieldmat)
test.assertTrue(libaster.debugJeveuxExists(tc3), msg="fieldmat / " + tc3)

# del mesh
# gc.collect()
DETRUIRE(CONCEPT=_F(NOM=mesh))
test.assertTrue(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)

# del model
# gc.collect()
DETRUIRE(CONCEPT=_F(NOM=model))
test.assertTrue(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)
test.assertTrue(libaster.debugJeveuxExists(tc1), msg="model / " + tc1)

# del material
# gc.collect()
DETRUIRE(CONCEPT=_F(NOM=material))
test.assertTrue(libaster.debugJeveuxExists(tc2), msg="material / " + tc2)

# del fieldmat
# gc.collect()
DETRUIRE(CONCEPT=_F(NOM=fieldmat))
test.assertFalse(libaster.debugJeveuxExists(tc0), msg="mesh / " + tc0)
test.assertFalse(libaster.debugJeveuxExists(tc1), msg="model / " + tc1)
test.assertFalse(libaster.debugJeveuxExists(tc2), msg="material / " + tc2)
test.assertFalse(libaster.debugJeveuxExists(tc2), msg="fieldmat / " + tc3)

# check for dependencies accessors
mesh = LIRE_MAILLAGE(UNITE=20, FORMAT='MED')
same = LIRE_MAILLAGE(UNITE=20, FORMAT='MED')

model = AFFE_MODELE(MAILLAGE=mesh,
                    AFFE=_F(TOUT='OUI',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='3D'))
deps = model.getDependencies()
test.assertTrue(mesh in deps)
test.assertFalse(same in deps)
test.assertEqual(len(deps), 1)

model.addDependency(mesh)
deps = model.getDependencies()
test.assertTrue(mesh in deps)
test.assertFalse(same in deps)
test.assertEqual(len(deps), 1)

model.addDependency(same)
deps = model.getDependencies()
test.assertTrue(mesh in deps)
test.assertTrue(same in deps)
test.assertEqual(len(deps), 2)

model.removeDependency(same)
deps = model.getDependencies()
test.assertTrue(mesh in deps)
test.assertFalse(same in deps)
test.assertEqual(len(deps), 1)

model.removeDependency(mesh)
deps = model.getDependencies()
test.assertFalse(mesh in deps)
test.assertFalse(same in deps)
test.assertEqual(len(deps), 0)

test.printSummary()

code_aster.close()
