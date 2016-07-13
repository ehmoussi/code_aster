#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

MAT=DEFI_MATERIAU(ELAS = _F(RHO = 7.8E03,
                            NU = 0.3,
                            E = 2.1E11,
                            AMOR_ALPHA = 1.6E-5,
                            AMOR_BETA = 16.,),)

MAYA=LIRE_MAILLAGE(FORMAT = 'MED',
                   UNITE = 20,)
MAYA=code_aster.Mesh()
MAYA.readMedFile('xxModalMechanics001a.med')

CHMAT=AFFE_MATERIAU(MAILLAGE = MAYA,
                    AFFE = _F(TOUT = 'OUI',
                              MATER = MAT,),)

POVOL=AFFE_MODELE(MAILLAGE = MAYA,
                  AFFE=_F(TOUT = 'OUI',
                          MODELISATION = '3D',
                          PHENOMENE = 'MECANIQUE',),)


imposedPres1 = code_aster.PressureDouble()
imposedPres1.setValue( code_aster.Loads.Pres, 500000. )
PRESSION = code_aster.DistributedPressureDouble()
PRESSION.setSupportModel( POVOL )
PRESSION.setValue( imposedPres1, "PRESSION" )
PRESSION.build()

imposedDof1 = code_aster.DisplacementDouble()
imposedDof1.setValue( code_aster.Loads.Dx, 0.0 )
imposedDof1.setValue( code_aster.Loads.Dy, 0.0 )
imposedDof1.setValue( code_aster.Loads.Dz, 0.0 )
CharMeca1 = code_aster.ImposedDisplacementDouble()
CharMeca1.setSupportModel( monModel )
CharMeca1.setValue( imposedDof1, "Bas" )
CharMeca1.build()
