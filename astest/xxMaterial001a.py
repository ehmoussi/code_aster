#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

ACIER=DEFI_MATERIAU(ELAS=_F(E=145200.0,
                            NU=0.0,
                            ALPHA=0.),
                    CIN1_CHAB=_F(R_0=75.5,
                                 R_I=85.27,
                                 B=19.34,
                                 C_I=10.0,
                                 K=1.0,
                                 W=0.0,
                                 G_0=36.68,
                                 A_I=1.0,),
                    LEMAITRE=_F(N=10.0,
                                UN_SUR_K=0.025,
                                UN_SUR_M=0.0,),
                    MONO_VISC1=_F(N=10.0,
                                  K=40.0,
                                  C=10.0,),
                    MONO_VISC2=_F(N=10.0,
                                  K=40.0,
                                  C=10.0,
                                  D=0.0,
                                  A=0.0,),
                    MONO_ISOT1=_F(R_0=75.5,
                                  Q=9.77,
                                  B=19.34,
                                  H=0.0,),
                    MONO_ISOT2=_F(R_0=75.5,
                                  Q1=9.77,
                                  B1=19.34,
                                  H=0.0,
                                  Q2=0.0,
                                  B2=0.0,),
                    MONO_CINE1=_F(D=36.68,),
                    MONO_CINE2=_F(D=36.68,
                                  GM=0.0,
                                  PM=0.0,
                                  C=0.0,),);

MATER2 = DEFI_MATERIAU( ELAS = _F( E = 220000.,
                                   NU = 0.33,
                                   ALPHA = 16.E-6,
                                   RHO = 8300., ), )

MATER2.debugPrint()

AFFMAT = AFFE_MATERIAU( MAILLAGE = mail1,
                        AFFE = (_F(TOUT = 'OUI',
                                   MATER = MATER2,),
                                _F(GROUP_MA = 'Haut',
                                   MATER = ACIER, ), ), )

AFFMAT.debugPrint()

# at least check that it passes here
test.assertTrue( True )
test.printSummary()
