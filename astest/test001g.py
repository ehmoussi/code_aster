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

# Définition d'une force

traction=code_aster.ForceReal()
# Affecter composantes/valeurs
traction.setValue(code_aster.PhysicalQuantityComponent.Fx, 1.0 )
traction.setValue(code_aster.PhysicalQuantityComponent.Fy, 2.0 )
traction.setValue(code_aster.PhysicalQuantityComponent.Fz, 3.0 )

# Mauvaise composante
# Dx n'est pas une composante de FORC_R !
with test.assertRaisesRegex( RuntimeError, "component is not allowed"):
    traction.setValue(code_aster.PhysicalQuantityComponent.Dx, 0.0 )

# Affichage
traction.debugPrint()

# On change la valeur d'une composante
traction.setValue(code_aster.PhysicalQuantityComponent.Fy, 4.0 )
# Affichage
traction.debugPrint()

test.printSummary()

code_aster.close()
