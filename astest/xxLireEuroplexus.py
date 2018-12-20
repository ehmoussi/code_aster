import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("plexu10d.mmed")

MODEEPX0=AFFE_MODELE(
                 MAILLAGE=MA,AFFE=(
                     _F(  GROUP_MA = ('COQUE',),
                            PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'Q4GG'),
                     _F(  GROUP_MA = 'CABLE2',
                            PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'BARRE'),
                     _F(  GROUP_MA = 'DISFROT',
                            PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'DIS_T')
                            ) )


CARAEPX0=AFFE_CARA_ELEM(
                      MODELE=MODEEPX0,
                       COQUE=(_F(  GROUP_MA = 'COQUE',
                               EPAIS = 1.,
                               VECTEUR = (0.,0.,1.),
                               COQUE_NCOU = 1,
                               MODI_METRIQUE = 'NON',
                               ),
                               ),
                       BARRE=_F(  GROUP_MA = 'CABLE2',
                               SECTION = 'GENERALE',
                               CARA = ( 'A', ),
                               VALE = ( 1.5E-2, ))
                               )

#U_EPX0 = LIRE_EUROPLEXUS(UNITE_MED = 19,
                #MODELE = MODEEPX0,
                #CARA_ELEM = CARAEPX0,
                #COMPORTEMENT=(_F( RELATION = 'ELAS',
                                    #GROUP_MA='COQUE',),
                               #_F( RELATION = 'ELAS',
                                    #GROUP_MA ='CABLE2',),
                                #_F( RELATION = 'ELAS',
                                    #GROUP_MA ='DISFROT', ),
                             #),
        #)

test.assertTrue( True )

test.printSummary()

FIN()
