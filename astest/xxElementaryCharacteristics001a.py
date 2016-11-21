# coding: utf-8

import code_aster
from code_aster.Commands import *

MA=code_aster.Mesh()
MA.readAsterMeshFile("xxElementaryCharacteristics.mail")

BETON=DEFI_MATERIAU(ELAS=_F(E = 1.E9,NU = 0.3,),)

MATAF=AFFE_MATERIAU(MAILLAGE=MA,
                    AFFE=(_F(GROUP_MA = 'MAI1',
                             MATER = BETON,)))

LEMOD=AFFE_MODELE(MAILLAGE=MA,
                  AFFE=(_F(GROUP_MA = 'MAI1',
                           PHENOMENE = 'MECANIQUE',
                           MODELISATION = 'DKTG',)))


LACAR=AFFE_CARA_ELEM(MODELE=LEMOD,
                     COQUE=(_F(GROUP_MA = 'MAI1',
                               EPAIS = .2,
                               ANGL_REP = (0.0, 0.0,),),),)

LACAR.debugPrint()
