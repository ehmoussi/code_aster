# coding=utf-8
#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA=code_aster.Mesh()
# LIRE_MAILLAGE(VERI_MAIL=_F(VERIF='OUI'),FORMAT='MED',)
MA.readMedFile("ssla311a.mmed")


MA=DEFI_GROUP( reuse=MA,   MAILLAGE=MA, 
                     CREA_GROUP_NO=_F( 
                         GROUP_MA = ( 'LPOP8',  'LPOP11',  'LP8P9', ))
                 )

MO=AFFE_MODELE(  MAILLAGE=MA,
                      AFFE=_F(  TOUT = 'OUI',
                             PHENOMENE = 'MECANIQUE',
                             MODELISATION = 'AXIS') )

MAT=DEFI_MATERIAU(ELAS=_F(  E = 2.E11,
                             NU = 0.3,
                             ALPHA = 0.) )

CHMAT=AFFE_MATERIAU(  MAILLAGE=MA,
                       AFFE=_F(  TOUT = 'OUI',
                              MATER = MAT) )

CH=AFFE_CHAR_MECA(  MODELE=MO,DDL_IMPO=(
                            _F(  GROUP_NO = 'LP8P9', DX = 0.),
                                     _F(  GROUP_NO = 'LPOP11', DY = 0.)),
                             FORCE_NODALE=_F(  GROUP_NO = 'PB',
                                            FY = 159.15)   )

CHAMDEPL=MECA_STATIQUE(        MODELE=MO,
                              CHAM_MATER=CHMAT,
                              EXCIT=_F( CHARGE = CH)
                           )
FOND=DEFI_FOND_FISS(    MAILLAGE=MA,
                        FOND_FISS=_F( GROUP_NO = ('P0',)),
                        SYME='OUI',
                        LEVRE_SUP=_F(MAILLE='M5309'),
                      )


G0=CALC_G(              RESULTAT=CHAMDEPL,
                        THETA=_F(
                                 DIRECTION=(1., 0., 0.,),
                                 FOND_FISS=FOND,
                                 MODULE=1.,
                                 R_INF=0.0025,
                                 R_SUP=0.0075),
                    )

#
# LA VALEUR DE REFERENCE VAUT 7.72E-4, LE RAYON LA FISSURE VAUT 0.1 :
# ET DONC LA VALEUR A TESTER VAUT 7.72E-4*0.1=7.72E-5
#
# la solution analytique est donnée par MURAKAMI (cf case 9.12)

TEST_TABLE(PRECISION=0.02,
           VALE_CALC=7.80932358732E-05,
           VALE_REFE=7.7200000000000006E-05,
           REFERENCE='ANALYTIQUE',
           NOM_PARA='G',
           TABLE=G0,)

test.assertEqual(G0.getType(), "TABLE_SDASTER")

test.printSummary()

FIN()
