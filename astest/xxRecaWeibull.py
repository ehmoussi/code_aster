import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ssna103a.mmed")

MA=DEFI_GROUP(      reuse=MA,
                            MAILLAGE=MA,CREA_GROUP_NO=(

                              _F(   GROUP_MA = 'CB'),
                              _F(   GROUP_MA = 'BO'),
                              _F(   GROUP_MA = 'OA'))
                             )

MO=AFFE_MODELE(   MAILLAGE=MA,
            AFFE=_F( TOUT = 'OUI',PHENOMENE = 'MECANIQUE',MODELISATION = 'AXIS')
                     )



ACIER=DEFI_MATERIAU(
               ELAS=_F(  E = 200000.,  NU = 0.3,  ALPHA = 0.),
               ECRO_LINE=_F(  D_SIGM_EPSI = 2000.,  SY = 750.),
               WEIBULL=_F( M = 24., VOLU_REFE = 1.25E-4, SIGM_REFE = 2600.0E0)
             )

ZERO=DEFI_FONCTION(   NOM_PARA='INST', VALE=(0., 0., 150.0, 0.0),
 )

TRAC50=DEFI_FONCTION(        NOM_PARA='INST',
                             PROL_DROITE='EXCLU',
                            PROL_GAUCHE='EXCLU',
                            VALE=(   0.,  0.,
                                  10.00,  10.68,
                                  20.00,  28.78,
                                  30.00,  30.31,
                                  40.00,  31.66,
                                  50.00,  32.53,
                                  60.00,  33.90,
                                  70.00,  34.38,
                                  80.00,  35.82,
                                  90.00,  36.69,
                                 100.00,  37.09,
                                 110.00,  37.37,
                                 120.00,  37.49,
                                 130.00,  38.45,
                                 140.00,  39.77,
                                 150.00,  44.39,

                                    )    )

TRAC100=DEFI_FONCTION(        NOM_PARA='INST',
                             PROL_DROITE='EXCLU',
                            PROL_GAUCHE='EXCLU',
                            VALE=(   0.,  0.,
                                  10.00,  20.57,
                                  20.00,  21.68,
                                  30.00,  23.32,
                                  40.00,  24.37,
                                  50.00,  24.66,
                                  60.00,  25.59,
                                  70.00,  25.84,
                                  80.00,  27.51,
                                  90.00,  28.44,
                                 100.00,  29.30,
                                 110.00,  29.68,
                                 120.00,  30.16,
                                 130.00,  30.18,
                                 140.00,  30.20,
                                 150.00,  30.95,

                                    )    )

TRAC150=DEFI_FONCTION(        NOM_PARA='INST',
                             PROL_DROITE='EXCLU',
                            PROL_GAUCHE='EXCLU',
                            VALE=(   0.,  0.,
                                  10.00,  11.33,
                                  20.00,  14.70,
                                  30.00,  14.79,
                                  40.00,  14.90,
                                  50.00,  18.62,
                                  60.00,  18.87,
                                  70.00,  19.00,
                                  80.00,  19.37,
                                  90.00,  19.61,
                                 100.00,  20.07,
                                 110.00,  21.19,
                                 120.00,  22.79,
                                 130.00,  23.28,
                                 140.00,  24.17,
                                 150.00,  24.41,

                                    )    )

CHARG50=AFFE_CHAR_MECA_F(   MODELE=MO,DDL_IMPO=(
                    _F(  GROUP_NO = 'CB',  DY = TRAC50),
                    _F(  GROUP_NO = 'BO',  DX = ZERO),
                    _F(  GROUP_NO = 'OA',  DY = ZERO))
                          )

CHARG100=AFFE_CHAR_MECA_F(   MODELE=MO,DDL_IMPO=(
                    _F(  GROUP_NO = 'CB',  DY = TRAC100),
                    _F(  GROUP_NO = 'BO',  DX = ZERO),
                    _F(  GROUP_NO = 'OA',  DY = ZERO))
                          )

CHARG150=AFFE_CHAR_MECA_F(   MODELE=MO,DDL_IMPO=(
                    _F(  GROUP_NO = 'CB',  DY = TRAC150),
                    _F(  GROUP_NO = 'BO',  DX = ZERO),
                    _F(  GROUP_NO = 'OA',  DY = ZERO))
                          )

TEMP50=CREA_CHAMP(OPERATION='AFFE', TYPE_CHAM='NOEU_TEMP_R',
MAILLAGE=MA,
               AFFE=_F(  TOUT = 'OUI', NOM_CMP = 'TEMP', VALE = -50.)
                    )

TEMP100=CREA_CHAMP(OPERATION='AFFE', TYPE_CHAM='NOEU_TEMP_R',
MAILLAGE=MA,
               AFFE=_F(  TOUT = 'OUI', NOM_CMP = 'TEMP', VALE = -100.)
                    )

TEMP150=CREA_CHAMP(OPERATION='AFFE', TYPE_CHAM='NOEU_TEMP_R',
MAILLAGE=MA,
               AFFE=_F(  TOUT = 'OUI', NOM_CMP = 'TEMP', VALE = -150.)
                    )

CM50=AFFE_MATERIAU(   MAILLAGE=MA,
                         AFFE=_F(  TOUT = 'OUI', MATER = ACIER),)


CM100=AFFE_MATERIAU(   MAILLAGE=MA,
                         AFFE=_F(  TOUT = 'OUI', MATER = ACIER),)

CM150=AFFE_MATERIAU(   MAILLAGE=MA,
                         AFFE=_F(  TOUT = 'OUI', MATER = ACIER),)

L_INST = code_aster.TimeStepManager()
L_INST.setTimeList( [ 10.*n for n in range(16)] )
L_INST.build()

U1=STAT_NON_LINE(
             MODELE=MO,    CHAM_MATER=CM50,EXCIT=(
              _F(  CHARGE = CHARG50),),
              COMPORTEMENT=_F(  RELATION = 'VMIS_ISOT_LINE'),
              NEWTON=_F( REAC_ITER = 1),
              INCREMENT=_F(  LIST_INST = L_INST, NUME_INST_FIN = 15),
            CONVERGENCE=_F(  RESI_GLOB_RELA = 1.E-6,
                          ITER_GLOB_MAXI = 100)
                        )

U2=STAT_NON_LINE(
                 MODELE=MO,
                 CHAM_MATER=CM100,
                 EXCIT=( _F(  CHARGE = CHARG100),),
                 COMPORTEMENT=_F(  RELATION = 'VMIS_ISOT_LINE'),
                 INCREMENT=_F(  LIST_INST = L_INST, NUME_INST_FIN = 15),
                 NEWTON=_F( REAC_ITER = 1),
                 CONVERGENCE=_F(  RESI_GLOB_RELA = 1.E-6,
                                  ITER_GLOB_MAXI = 100)
                        )

U3=STAT_NON_LINE(
                 MODELE=MO,
                 CHAM_MATER=CM150,
                 EXCIT=( _F(  CHARGE = CHARG150),),
                 NEWTON=_F( REAC_ITER = 1),
                 COMPORTEMENT=_F(  RELATION = 'VMIS_ISOT_LINE'),
                 INCREMENT=_F(  LIST_INST = L_INST, NUME_INST_FIN = 15),
                 CONVERGENCE=_F(  RESI_GLOB_RELA = 1.E-6,
                                  ITER_GLOB_MAXI = 100)
                        )

T1=RECA_WEIBULL(   LIST_PARA=('SIGM_REFE','M',),
                   RESU=( _F(   EVOL_NOLI = U1,
                                CHAM_MATER = CM50,
                                TEMPE = -50.,
                                LIST_INST_RUPT = ( 10., 20., 30.,
                                                   40., 50., 60., 70., 80., 90., 100.,
                                                  110.,  120.,  130., 140.,  150.,),
                                MODELE = MO,
                                TOUT = 'OUI',
                                COEF_MULT = 12.5664),

                          _F(   EVOL_NOLI = U2,
                                CHAM_MATER = CM100,
                                TEMPE = -100.,

                                LIST_INST_RUPT = ( 10.,  20., 30.,
                                                   40., 50., 60., 70., 80., 90., 100.,
                                                   110.,  120.,  130., 140.,  150.,),

                                MODELE = MO,
                                TOUT = 'OUI',
                                COEF_MULT = 12.5664),
                         _F(    EVOL_NOLI = U3,
                                CHAM_MATER = CM150,
                                TEMPE = -150.,

                                LIST_INST_RUPT = (  10., 20., 30.,
                                                    40., 50., 60., 70., 80., 90., 100.,
                                                    110.,  120.,  130., 140.,  150.,),

                                MODELE = MO,
                                TOUT = 'OUI',
                                COEF_MULT = 12.5664)),

                   METHODE='MAXI_VRAI',
                   CORR_PLAST='NON',
                   OPTION='SIGM_ELMOY',
                   ITER_GLOB_MAXI=25,
                   INCO_GLOB_RELA=1.E-3
                   )

test.assertTrue( True )

FIN()
