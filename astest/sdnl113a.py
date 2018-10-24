# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
from code_aster.Commands import DEFI_FONCTION

def F_ACCEL() : 
	ACCEL=DEFI_FONCTION( NOM_PARA='INST',
                         NOM_RESU='AXTAB1',
                         INTERPOL='LIN',
                         PROL_DROITE='EXCLU',
                         PROL_GAUCHE='EXCLU',
      VALE=(
     0.00000000,      -0.02176580,
     0.01000000,      -0.09337440,
     0.02000000,      -0.12918360,
     0.03000000,      -0.02176580,
     0.04000000,       0.08565200,
     0.05000000,       0.19306980,
     0.06000000,       0.08565200,
     0.07000000,       0.01404340,
     0.08000000,      -0.05757500,
     0.09000000,      -0.02176580,
     0.10000000,       0.01404340,
     0.11000000,       0.04985260,
     0.12000000,      -0.02176580,
     0.13000000,       0.01404340,
     0.14000000,       0.15727040,
     0.15000000,       0.15727040,
     0.16000000,      -0.02176580,
     0.17000000,      -0.16499280,
     0.18000000,      -0.23660140,
     0.19000000,      -0.30821000,
     0.20000000,      -0.23660140,
     ))

	return ACCEL
