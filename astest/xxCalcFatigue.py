import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("sslv135a.mmed")

MA=DEFI_GROUP(reuse = MA,
                ALARME='OUI',
                CREA_GROUP_NO=(_F(GROUP_MA='FACE1',
                                  CRIT_NOEUD='TOUS'),
                               _F(GROUP_MA='FACE2',
                                  CRIT_NOEUD='TOUS'),
                               _F(GROUP_MA='FACE3',
                                  CRIT_NOEUD='TOUS'),
                               _F(GROUP_MA='FACE4',
                                CRIT_NOEUD='TOUS'),
                               _F(GROUP_MA='FACE5',
                                  CRIT_NOEUD='TOUS'),
                               _F(GROUP_MA='FACE6',
                                  CRIT_NOEUD='TOUS')),
                MAILLAGE=MA,
               );

MA=DEFI_GROUP(reuse = MA,
                ALARME='OUI',
                CREA_GROUP_MA=(_F(OPTION='APPUI',
                                  TYPE_APPUI='AU_MOINS_UN',
                                  GROUP_NO='FACE1',
                                  NOM='FACE1_3D'),
                               _F(OPTION='APPUI',
                                  TYPE_APPUI='AU_MOINS_UN',
                                  GROUP_NO='FACE2',
                                  NOM='FACE2_3D'),
                               _F(OPTION='APPUI',
                                  TYPE_APPUI='AU_MOINS_UN',
                                  GROUP_NO='FACE3',
                                  NOM='FACE3_3D'),
                               _F(OPTION='APPUI',
                                  TYPE_APPUI='AU_MOINS_UN',
                                  GROUP_NO='FACE4',
                                  NOM='FACE4_3D'),
                               _F(OPTION='APPUI',
                                  TYPE_APPUI='AU_MOINS_UN',
                                  GROUP_NO='FACE5',
                                  NOM='FACE5_3D'),
                               _F(OPTION='APPUI',
                                  TYPE_APPUI='AU_MOINS_UN',
                                  GROUP_NO='FACE6',
                                  NOM='FACE6_3D')),
                MAILLAGE=MA,
               );

WHOL=DEFI_FONCTION(       NOM_PARA='SIGM',
                            INTERPOL='LOG',
                          PROL_DROITE='LINEAIRE',
                         PROL_GAUCHE='LINEAIRE',
                         VALE=(  138.,    1000000.,
                                 152.,     500000.,
                                 165.,     200000.,
                                 180.,     100000.,
                                 200.,      50000.,
                                 250.,      20000.,
                                 295.,      12000.,
                                 305.,      10000.,
                                 340.,       5000.,
                                 430.,       2000.,
                                 540.,       1000.,
                                 690.,        500.,
                                 930.,        200.,
                                1210.,        100.,
                                1590.,         50.,
                                2210.,         20.,
                                2900.,         10.,  )  )

COEF   = DEFI_FONCTION ( NOM_PARA    ='INST',
                          PROL_DROITE  ='LINEAIRE',
                          PROL_GAUCHE ='LINEAIRE',
                          VALE        =( 0.,    0.,
                                         1.,  100.,
                                         2.,    0.,
                                         3., -100.,
                                         4.,    0.,
                                        )
                       )

ACIER   = DEFI_MATERIAU   ( ELAS           =_F( E         = 200000.,
                                                NU        = .3,
                                                ALPHA     = 0. ),
                          )


LINST = code_aster.TimeStepManager()
LINST.setTimeList( [4.0*n/8 for n in range(9)] )
LINST.build()

TROISD   = AFFE_MODELE    ( MAILLAGE   =    MA,
                            AFFE       =_F ( PHENOMENE    = 'MECANIQUE',
                                             MODELISATION = '3D',
                                             TOUT         = 'OUI'    ))

MAT   = AFFE_MATERIAU    ( MAILLAGE    =   MA,
                           AFFE        =_F ( TOUT       = 'OUI',
                                             MATER      = ACIER,
                                             ))

TR_CS  = AFFE_CHAR_MECA (
           MODELE       =  TROISD,
           FACE_IMPO    =(_F( GROUP_MA= 'FACE3' ,DX=0.),
                          _F( GROUP_MA= 'FACE2' ,DY=0.) ),
           DDL_IMPO     =(_F( GROUP_NO= 'P3' , DZ=0.) ),
           FORCE_FACE   =(_F( GROUP_MA= 'FACE4', FX=1.),
                          _F( GROUP_MA= 'FACE1', FY=-2.) )
                         );

SOL_NL = STAT_NON_LINE ( TITRE      =
                'TEST TRACTION-COMPRESSION ALTERNEE - PLAN CRITIQUE',
                        MODELE     =   TROISD,
                        CHAM_MATER =   MAT,
                        EXCIT      =_F ( CHARGE       = TR_CS,
                                         FONC_MULT    = COEF,
                                         TYPE_CHARGE  = 'FIXE_CSTE'),
                        COMPORTEMENT  =_F ( RELATION     = 'ELAS',
                                         DEFORMATION  = 'PETIT',
                                         TOUT         = 'OUI'    ),
                        INCREMENT  =_F ( LIST_INST    = LINST, ),
                        NEWTON     =_F ( MATRICE      = 'ELASTIQUE',
                                         REAC_INCR    = 0 ))

SOL_NL = CALC_CHAMP( reuse    = SOL_NL,
                  RESULTAT = SOL_NL,
                  GROUP_MA = ('FACE1_3D', 'FACE2_3D', 'FACE3_3D','CUBE'),
                  CONTRAINTE='SIGM_NOEU',DEFORMATION='EPSI_NOEU'
                )

FANL1=CALC_FATIGUE( TYPE_CALCUL   = 'FATIGUE_MULTI',
                    OPTION        = 'DOMA_NOEUD',
                    TYPE_CHARGE   = 'PERIODIQUE',
                    RESULTAT      = SOL_NL,
                    CHAM_MATER    = MAT,
                    GROUP_MA      = ('FACE1', 'FACE2', 'FACE3'),
                    MAILLAGE      = MA,
                    CRITERE       = 'VMIS_TRESCA'
                  )

test.assertTrue( True )

FIN()
