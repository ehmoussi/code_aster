import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("sslv100c.mmed")

MO=AFFE_MODELE(            MAILLAGE=MA,
                                  AFFE=_F(  TOUT = 'OUI',
                                         PHENOMENE = 'MECANIQUE',
                                         MODELISATION = 'D_PLAN'))

MAT=DEFI_MATERIAU(   ELAS=_F(  E     = 200000.,
                              NU    = 0.3,
                              ALPHA = 0.     ),
                    RCCM=_F(  M_KE  = 1.7,
                              N_KE  = 0.3,
                              SM    = 200.   ),
                )

CM=AFFE_MATERIAU(        MAILLAGE=MA,
                                  AFFE=_F(  TOUT = 'OUI',
                                         MATER = MAT))

CH=AFFE_CHAR_MECA(         MODELE=MO,
                              DDL_IMPO=_F(  GROUP_NO = 'BORDAB',  DY = 0.),
                             FACE_IMPO=_F(  GROUP_MA = 'FACEEF',  DNOR = 0.),
                              PRES_REP=_F(  GROUP_MA = 'FACEAE',  PRES = 60.))

RESU=MECA_STATIQUE(MODELE=MO,
                   CHAM_MATER=CM,
                   EXCIT=_F(CHARGE=CH,),
                    );

RESU=CALC_CHAMP(reuse=RESU,RESULTAT=RESU,CONTRAINTE=('SIGM_ELNO'))

T_RESU=MACR_LIGN_COUPE(RESULTAT=RESU,NOM_CHAM='SIGM_ELNO',
                   LIGN_COUPE=(
                     _F(TYPE='SEGMENT', NB_POINTS=100, INTITULE='CH1',
                        COOR_ORIG=( 9.2387974262238E-02, 3.8268297910690E-02, ),
                        COOR_EXTR=( 1.8477588891983E-01, 7.6536655426025E-02, )),
                     _F(TYPE='SEGMENT', NB_POINTS=100, INTITULE='CH2',
                        COOR_ORIG=( 0., 0., ),
                        COOR_EXTR=( 1.8477588891983E-01, 7.6536655426025E-02, )),
                  ))

test.assertTrue( True )

FIN()
