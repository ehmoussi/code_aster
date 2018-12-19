import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAIL = code_aster.Mesh()
MAIL.readGmshFile("zzzz186a.msh")

DEFI_GROUP(reuse =MAIL,
                MAILLAGE=MAIL,
                CREA_GROUP_MA=(
                _F(GROUP_MA='GM10000',NOM='TUYAU',),
                _F(GROUP_MA='GM10001',NOM='ENCAST',),
                _F(GROUP_MA='GM10002',NOM='SYMETRIE',),
                _F(GROUP_MA='GM10005',NOM='EFOND',),
                _F(GROUP_MA='GM10004',NOM='SURFINT',),
                _F(GROUP_MA='GM10003',NOM='SURFEXT',),
                ),);

DEFI_GROUP(reuse =MAIL,
                MAILLAGE=MAIL,
                CREA_GROUP_NO=(_F(GROUP_MA='EFOND',),
                               _F(GROUP_MA='SURFINT',),
                               _F(GROUP_MA='SURFEXT',),
                               _F(GROUP_MA='ENCAST',),
                               _F(OPTION='PLAN',
                                  NOM='PLANY',
                                  POINT=(3.6,3.6,0.0,),
                                  VECT_NORMALE=(0.0,1.0,0.0,),
                                  PRECISION=0.001,),
                               _F(OPTION='ENV_CYLINDRE',
                                  NOM='REXT',
                                  POINT=(3.6,3.6,0.0,),
                                  RAYON=0.2,
                                  VECT_NORMALE=(1.0,0.0,0.0,),
                                  PRECISION=0.001,),
                               _F(INTERSEC=('EFOND','PLANY','REXT',),
                                  NOM='PB',),),);



MADMECA=AFFE_MODELE(MAILLAGE=MAIL,
                    AFFE=_F(TOUT='OUI',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='3D',),);


FYTOT = 100000.0;

EPTUB = 0.02;

REXT = 0.2;


RINT=REXT-EPTUB;

SINT=3.14159*(RINT*RINT);

SEXT=3.14159*(REXT*REXT);

SFON=SEXT-SINT;

FYREP=FYTOT/SFON;

CHARG1=AFFE_CHAR_MECA(MODELE=MADMECA,
                      DDL_IMPO=(_F(GROUP_MA='ENCAST',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0,),
                                _F(GROUP_MA='SYMETRIE',
                                   DZ=0.0,),),
                      FORCE_FACE=_F(GROUP_MA='EFOND',
                                    FY=FYREP,),);

ACIER=DEFI_MATERIAU(ELAS=_F(E=204000.0000000,
                            NU=0.3,),);

CHMAT=AFFE_MATERIAU(MAILLAGE=MAIL,
                    AFFE=_F(TOUT='OUI', MATER=ACIER,),
                    );

RESU1=MECA_STATIQUE(MODELE=MADMECA,
                     CHAM_MATER=CHMAT,
                     EXCIT=_F(CHARGE=CHARG1,),
                     );

RESUT1=CALC_CHAMP(RESULTAT=RESU1,
                  CONTRAINTE=('SIEF_ELNO','SIEF_NOEU',),);


T_MECA_R=MACR_LIGN_COUPE(RESULTAT=RESUT1,
                         NOM_CHAM='SIEF_NOEU',
                         MODELE=MADMECA,
                         LIGN_COUPE=_F(NB_POINTS=3,
                                       COOR_ORIG=(0.18,0.1,0.0,),
                                       COOR_EXTR=(0.185,0.1,0.0,),
                                       DISTANCE_MAX=1.E-4,),);

T_MECA_S=MACR_LIGN_COUPE(RESULTAT=RESUT1,
                         NOM_CHAM='SIEF_NOEU',
                         MODELE=MADMECA,
                         LIGN_COUPE=_F(NB_POINTS=9,
                                       COOR_ORIG=(0.185,0.1,0.0,),
                                       COOR_EXTR=(0.200,0.1,0.0,),
                                       DISTANCE_MAX=1.E-4,),);


IMPR_OAR(TYPE_CALC  = 'COMPOSANT',
         DIAMETRE  = 0.2,
         REVET     = 'OUI',
         RESU_MECA = _F(NUM_CHAR=1,
                        TYPE='MX',
                        TABLE=T_MECA_S,
                        TABLE_S = T_MECA_R),)

test.assertTrue( True )

FIN()
