import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ssna108a.mmed")

MO=AFFE_MODELE(   MAILLAGE=MA,
            AFFE=_F( TOUT = 'OUI',PHENOMENE = 'MECANIQUE',MODELISATION = 'AXIS')
           )

ACIER=DEFI_MATERIAU(
               ELAS=_F(  E = 200000.,  NU = 0.3,  ALPHA = 0.),
             )

CM=AFFE_MATERIAU(   MAILLAGE=MA,
                         AFFE=_F(  TOUT = 'OUI', MATER = ACIER)  )

ZERO=DEFI_FONCTION(        NOM_PARA='INST',
                             PROL_DROITE='EXCLU',
                            PROL_GAUCHE='EXCLU',
                            VALE=(   0.,  0.,
                                   100.,  0., )    )

TRAC=DEFI_FONCTION(        NOM_PARA='INST',
                             PROL_DROITE='EXCLU',
                            PROL_GAUCHE='EXCLU',
                            VALE=(   0.,  0.,
                                   100.,  1., )    )

CHARG=AFFE_CHAR_MECA_F(   MODELE=MO,DDL_IMPO=(
                    _F(  GROUP_NO = 'DEPLIMPO',  DY = TRAC),
                    _F(  GROUP_NO = 'SYMETRIE',  DX = ZERO),
                    _F(  GROUP_NO = 'LIGAMENT',  DY = ZERO))
                          )

L_INST=DEFI_LIST_REEL(    DEBUT=0.,
                            INTERVALLE=_F(  JUSQU_A = 10.,  NOMBRE = 10)
                        )

L_INST = code_aster.TimeStepManager()
L_INST.setTimeList( range(11) )
L_INST.build()

T=STAT_NON_LINE(
                MODELE=MO,
                CHAM_MATER=CM,
                EXCIT=_F(CHARGE = CHARG),
                INCREMENT=_F(LIST_INST = L_INST),
                CONVERGENCE=_F(RESI_GLOB_RELA = 1.0E-04,
                                ITER_GLOB_MAXI = 25)
              )

U=EXTR_RESU(RESULTAT=T,ARCHIVAGE=_F(NUME_ORDRE=(1,2,3,4,5,6,7,8,9,10),))

INFO_RESU(RESULTAT=T)

test.assertTrue( True )

FIN()
