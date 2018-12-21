import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

ma = code_aster.Mesh()
ma.readMedFile("fdlv114a.mmed")

ma=DEFI_GROUP(MAILLAGE=ma,reuse=ma,CREA_GROUP_NO=_F(NOM='PTEST',INTERSEC=('N_CL_FIX','N_POST_1')))

mo=AFFE_MODELE(MAILLAGE=ma,
               AFFE=_F(GROUP_MA='STRU_2D',
                       PHENOMENE='MECANIQUE',
                       MODELISATION='DKT',),);

mat=DEFI_MATERIAU(ELAS=_F(E=1.95E11,
                          NU=0.3,
                          RHO=7850.,),);

chmt_mat=AFFE_MATERIAU(MAILLAGE=ma,
                       AFFE=_F(GROUP_MA='STRU_2D',
                               MATER=mat,),);

aff_meca=AFFE_CHAR_MECA(MODELE=mo,
                        DDL_IMPO=(_F(GROUP_NO='N_CL_FIX',
                                     DX=0.,
                                     DY=0.,
                                     DZ=0.,),
                                  _F(GROUP_NO=('N_POST_2','N_POST_4'),
                                     DX=0.,
                                     DY=0.,
                                     DZ=0.,)))

aff_car=AFFE_CARA_ELEM(MODELE=mo,
                       COQUE=_F(GROUP_MA='STRU_2D',
                                EPAIS=0.015,
                                COQUE_NCOU=1,),);

ASSEMBLAGE(MODELE=mo,
           CHAM_MATER=chmt_mat,
           CARA_ELEM=aff_car,
           CHARGE=aff_meca,
           NUME_DDL=CO('nddl'),
           MATR_ASSE=(_F(MATRICE=CO('matrigi'),
                         OPTION='RIGI_MECA',),
                      _F(MATRICE=CO('matmass'),
                         OPTION='MASS_MECA',),),);

MASSINER=POST_ELEM(MASS_INER=_F(TOUT='OUI',),
                   MODELE=mo,
                   CHAM_MATER=chmt_mat,
                   CARA_ELEM=aff_car,);

IMPR_TABLE(TABLE=MASSINER,
           UNITE=8,
           NOM_PARA=('LIEU','ENTITE','MASSE',),);

modes=CALC_MODES(MATR_RIGI=matrigi,
                 MATR_MASS=matmass,
                 OPTION='BANDE',
                 CALC_FREQ=_F(FREQ=(0.0, 10.0,), ),
                 SOLVEUR_MODAL=_F(METHODE='SORENSEN', ),
                 )

EAU = DEFI_MATERIAU(THER=_F(LAMBDA=1.0, RHO_CP=1000.))

MATFLUI = AFFE_MATERIAU(MAILLAGE=ma,
                        AFFE=_F( GROUP_MA=( 'VOL_FLU', 'STRU_2D'), MATER=EAU),)

MODELFLU = AFFE_MODELE(MAILLAGE=ma,
                           AFFE=_F( GROUP_MA=( 'VOL_FLU', 'STRU_2D'), 
                                    MODELISATION='3D',
                                    PHENOMENE='THERMIQUE'), )


PRESIMPO = AFFE_CHAR_THER(MODELE=MODELFLU, TEMP_IMPO=_F(TEMP=0.0, GROUP_NO=('N_SF_LIB', ),))

METHER=CALC_MATR_ELEM(OPTION='RIGI_THER', MODELE=MODELFLU, CHAM_MATER=MATFLUI, CHARGE=PRESIMPO,)

NUDDLT=NUME_DDL(MATR_RIGI=METHER,)

RIGITH=ASSE_MATRICE(MATR_ELEM=METHER, NUME_DDL =NUDDLT,);

RIGITH=FACTORISER(reuse=RIGITH,  MATR_ASSE=RIGITH   )

result = CALC_CHAM_FLUI(RIGI_THER = RIGITH,
                        MODE_MECA = modes,
                        POTENTIEL = 'DEPL',
                        EXCIT = _F(CHARGE=PRESIMPO,))

test.assertTrue( True )

FIN()
