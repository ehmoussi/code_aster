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

import code_aster
from code_aster.Commands import *
from code_aster.Supervis.ExecutionParameter import ExecutionParameter, Options

test = code_aster.TestCase()

# extract from zzzz351a
# DEBUT(CODE=_F(NIV_PUB_WEB='INTERNET'), DEBUG=_F(SDVERI='OUI'))
code_aster.init("--abort")

params = ExecutionParameter()

test.assertTrue(params.option & Options.UseLegacyMode)
params.disable(Options.UseLegacyMode)
test.assertFalse(params.option & Options.UseLegacyMode)

# MAIL = LIRE_MAILLAGE(UNITE=20, FORMAT='MED',)
MAIL = code_aster.Mesh()
MAIL.readMedFile('zzzz351a.mmed')

MODELE = AFFE_MODELE(MAILLAGE=MAIL,
                     AFFE=_F(TOUT='OUI', PHENOMENE='MECANIQUE',
                             MODELISATION='3D'))

MAT = DEFI_MATERIAU(ELAS=_F(E=200.e9, NU=0.3, RHO=8000.0,),)

CHMAT = AFFE_MATERIAU(MAILLAGE=MAIL,
                      AFFE=_F(TOUT='OUI', MATER=MAT,),)

BLOCAGE = AFFE_CHAR_MECA(MODELE=MODELE,
                         DDL_IMPO=_F(GROUP_MA='BLOK',
                                     DX=0.0,
                                     DY=0.0,
                                     DZ=0.0,),)

asse = ASSEMBLAGE(MODELE=MODELE,
                  CHAM_MATER=CHMAT,
                  CHARGE=BLOCAGE,
                  NUME_DDL=CO('NUMEDDL'),
                  MATR_ASSE=(_F(MATRICE=CO('K1'),
                                OPTION='RIGI_MECA',),
                             _F(MATRICE=CO('M1'),
                                OPTION='MASS_MECA',),),)
test.assertEqual(len(asse), 4)
test.assertIsNone(asse.main)

NUMEDDL = asse.NUMEDDL
K1 = asse.K1
M1 = asse.M1

# 1. Calcul de reference avec les matrices "completes" :
#--------------------------------------------------------
MODE1 = CALC_MODES(OPTION='BANDE',
                   MATR_RIGI=K1,
                   MATR_MASS=M1,
                   CALC_FREQ=_F(FREQ=(10., 250.)),
                   VERI_MODE=_F(SEUIL=1e-03)
                   )

TEST_RESU(RESU=_F(RESULTAT=MODE1, NUME_MODE=2,
                  PARA='FREQ', VALE_CALC=85.631015163879, ))

FIN()

test.printSummary()
