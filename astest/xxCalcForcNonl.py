import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("sdls119a.mmed")


MA = DEFI_GROUP( reuse = MA ,
                   MAILLAGE = MA ,
                   CREA_GROUP_NO = ( _F( GROUP_MA = 'DBAS' , ) ,
                                     _F( GROUP_MA = 'RES0' , ) ,
                                     _F( GROUP_MA = 'RESL' , ) ,
                                     _F( GROUP_MA = 'RESS' , ) ,
                                     _F( GROUP_MA = 'RESB' , ) , ) , );
#
mode = AFFE_MODELE( MAILLAGE = MA ,
                    AFFE = (
                             _F( GROUP_MA = ( 'RESS' , ) ,
                                 PHENOMENE = 'MECANIQUE',
                                 MODELISATION = 'DIS_T') ,
                             _F( GROUP_MA = ( 'RESL' , ) ,
                                 PHENOMENE = 'MECANIQUE',
                                 MODELISATION = 'DIS_T') ,
                            _F( GROUP_MA = ( 'RES0' , ) ,
                                 PHENOMENE = 'MECANIQUE',
                                 MODELISATION = 'DIS_T') ,
                             _F( GROUP_MA = ( 'DAL1' , ) ,
                                 PHENOMENE = 'MECANIQUE',
                                 MODELISATION = 'DKT') ,
                             _F( GROUP_MA = 'RESH' ,
                                 PHENOMENE = 'MECANIQUE' ,
                                 MODELISATION = 'DIS_T' , ) , ) , );
#
kressort = 1.E8 ;
kressorG = 1.E15 ;
#
cara = AFFE_CARA_ELEM( MODELE = mode ,
                       DISCRET = ( _F( GROUP_MA = 'RESH' ,
                                          REPERE = 'LOCAL' ,
                                          CARA = 'K_T_D_L' ,
                                          VALE = ( 1.0 , 0.0 ,0.0 , ) , ) ,
                                    _F( GROUP_MA = 'RESH' ,
                                          REPERE = 'LOCAL' ,
                                          CARA = 'A_T_D_L' ,
                                          VALE = ( 0.0 , 0.0 ,0.0 , ) , ) ,
                                    _F( GROUP_MA = 'RESH' ,
                                          REPERE = 'LOCAL' ,
                                          CARA = 'M_T_L' ,
                                          VALE = ( 0.,0.,0.,0.,0.,0.,0.,0.,0.,
                                          0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,) , ) ,
                                    _F( GROUP_MA = 'RESL' ,
                                          REPERE = 'LOCAL' ,
                                          CARA = 'K_T_D_L' ,
                                          VALE = ( kressorG , kressorG ,kressorG , ) , ) ,
                                    _F( GROUP_MA = 'RESL' ,
                                          REPERE = 'LOCAL' ,
                                          CARA = 'A_T_D_L' ,
                                          VALE = ( 0. , 0. ,0. , ) , ) ,
                                    _F( GROUP_MA = 'RESL' ,
                                          REPERE = 'LOCAL' ,
                                          CARA = 'M_T_L' ,
                                          VALE = ( 0.,0.,0.,0.,0.,0.,0.,0.,0.,
                                          0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,) , ) ,
                                      _F( GROUP_MA = 'RESS' ,
                                          REPERE = 'LOCAL' ,
                                          CARA = 'K_T_D_L' ,
                                          VALE = ( kressort , kressorG , kressorG ,) , ) ,
                                    _F( GROUP_MA = 'RESS' ,
                                          REPERE = 'LOCAL' ,
                                          CARA = 'M_T_L' ,
                                          VALE = ( 0.,0.,0.,0.,0.,0.,0.,0.,0.,
                                          0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,) , ) ,
                                      _F( GROUP_MA = 'RES0' ,
                                           REPERE = 'GLOBAL' ,
                                           CARA = 'M_T_D_N' ,
                                           VALE = 1.e-1 , ) ,
                                     ),
                       COQUE=        _F( GROUP_MA = 'DAL1' ,
                                          A_CIS=0.833333333,
                                          EPAIS=1.,),
                                           );

mat1 = DEFI_MATERIAU( ELAS = _F( E   = 1.4E8 ,
                                 NU  = 0.3  ,
                                 RHO = 2500.,
                                 AMOR_ALPHA = 0.005 ,
                                 AMOR_BETA = 0.1 , ) , );

matbid = DEFI_MATERIAU( ELAS = _F( E   = 1.E12 ,
                                 NU  = 0.3  ,
                                 RHO = 2500., ) , );

matres = DEFI_MATERIAU( DIS_CONTACT = _F( RIGI_NOR = kressorG ,
                                          DIST_1 = 1.e-6 ,
                                          DIST_2 = 1.e-6,
                                        ), );

chmat = AFFE_MATERIAU( MAILLAGE = MA ,
                    AFFE =( _F( GROUP_MA = 'DAL1' ,
                                MATER = mat1 ),
                            _F( GROUP_MA = 'RESL' ,
                                MATER = matres ),
                            _F( GROUP_MA = 'RESS' ,
                                MATER = matbid ),
                            _F( GROUP_MA = 'RESH' ,
                                MATER = matbid ),
                            _F( GROUP_MA = 'RES0' ,
                                MATER = matbid ),
                                 ) , );

depimp = AFFE_CHAR_MECA( MODELE = mode ,
                         DDL_IMPO=( _F(  GROUP_NO =
                                         ( 'R1' , 'R2' , ) ,
                                         LIAISON = 'ENCASTRE' , ) ,
                                    _F(  GROUP_NO = 'RESB' ,
                                         DX = 0. , DY = 0. , DZ = 0.) ,
                                    _F(  GROUP_NO = 'RES0' ,
                                         DZ = 0. ) ,
                                    _F(  GROUP_MA =
                                          ( 'DAL1'  , ) ,
                                          DZ = 0., DRY = 0. ,) ,
                                          ) , );

rigielem = CALC_MATR_ELEM(OPTION="RIGI_MECA", MODELE=mode, CHARGE=depimp, CHAM_MATER=chmat, CARA_ELEM=cara)

masselem = CALC_MATR_ELEM(OPTION="MASS_MECA", MODELE=mode, CHARGE=depimp, CHAM_MATER=chmat, CARA_ELEM=cara)

numeddl = NUME_DDL(MATR_RIGI=rigielem)

rigidite = ASSE_MATRICE(MATR_ELEM=rigielem, NUME_DDL=numeddl)

masse = ASSE_MATRICE(MATR_ELEM=masselem, NUME_DDL=numeddl)

EVOL=DYNA_VIBRA(TYPE_CALCUL='TRAN',BASE_CALCUL='PHYS',
                  MATR_MASS=masse, MATR_RIGI=rigidite,
                  SCHEMA_TEMPS=_F(SCHEMA='NEWMARK',),
                  INCREMENT=_F(PAS=0.01, INST_FIN=0.05),
                )

resunl = CALC_FORC_NONL( RESULTAT = EVOL , TOUT_ORDRE = 'OUI'    ,
                    CHAM_MATER=chmat, CARA_ELEM=cara, MODELE=mode,
              COMPORTEMENT = ( _F( RELATION = 'ELAS',
                                GROUP_MA = ( 'DAL1' ,
                                 'RESH','RESS','RES0', ),) ,
                            _F( RELATION = 'DIS_CHOC' ,
                                GROUP_MA = 'RESL' , ) ,
                                    ) ,
                   )

test.assertTrue( True )

FIN()
