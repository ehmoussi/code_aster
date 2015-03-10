# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

import unittest

from code_aster.Cata.Commands import *
from code_aster.Cata.DataStructure import *


class TestSyntaxChecker( unittest.TestCase ):

    def _check_type( self, obj, typ ):
        """utility"""
        assert type( obj ) is typ,  'unexpected type: {!r}'.format( obj )

    def test01_minimal( self ):
        """check a simple command"""
        mesh = LIRE_MAILLAGE(FORMAT = 'MED',
                             UNITE = 21,)
        self._check_type( mesh, maillage_sdaster )

    def test02_simple_study( self ):
        """simulate a simple study"""
        monMaillage = LIRE_MAILLAGE(FORMAT = 'MED',
                                    UNITE = 21,)

        modeleNum1 = AFFE_MODELE(MAILLAGE=monMaillage,
                                 AFFE=_F(TOUT='OUI',
                                         PHENOMENE='MECANIQUE',
                                         MODELISATION='3D',),)
        self._check_type( modeleNum1, modele_sdaster )

        RHO_D=1.5E+04
        A_D=3.4390E-03
        M_D=RHO_D * A_D * 1.

        CP_D_T2=AFFE_CARA_ELEM(MODELE=modeleNum1,
                               DISCRET=_F(REPERE='LOCAL',
                                          MAILLE= 'P1',
                                          CARA='M_T_N',
                                          VALE=(M_D,-1.,M_D,0.5,0.5,M_D,),),)
        self._check_type( CP_D_T2, cara_elem )

        mater1 = DEFI_MATERIAU(ELAS=_F(E=2.e11,
                                       NU=0.3,),)
        self._check_type( mater1, mater_sdaster )

        affe_mater1 = AFFE_MATERIAU(MAILLAGE=monMaillage,
                                    AFFE=(_F(TOUT='OUI',
                                             MATER=mater1),),);
        self._check_type( affe_mater1, cham_mater )


        char_meca1 = AFFE_CHAR_MECA(MODELE=modeleNum1,
                                    DDL_IMPO=(_F(DX=0.,
                                                 GROUP_NO='Bas'),
                                              _F(DY=0.,
                                                 GROUP_NO='Bas'),
                                              _F(DZ=0.,
                                                 GROUP_NO='Bas'),),)
        self._check_type( char_meca1, char_meca )

        char_meca2 = AFFE_CHAR_MECA(MODELE=modeleNum1,
                                    PRES_REP=_F(PRES=1000.,
                                                GROUP_MA='Haut'),)
        self._check_type( char_meca2, char_meca )

        modeleNum2 = AFFE_MODELE(MAILLAGE=monMaillage,
                                 AFFE=(_F(TOUT='OUI',
                                          PHENOMENE='MECANIQUE',
                                          MODELISATION='3D',),
                                       _F(GROUP_MA='Haut',
                                          PHENOMENE='THERMIQUE',
                                          MODELISATION='PLAN'),),)
        self._check_type( modeleNum2, modele_sdaster )

        char_meca3 = AFFE_CHAR_MECA(MODELE=modeleNum1,
                                    DDL_IMPO=_F(DX=0.,
                                                DY=0.,
                                                DZ=0.,
                                                GROUP_NO='Bas',),)
        self._check_type( char_meca3, char_meca )


if __name__ == '__main__':
    unittest.main()
