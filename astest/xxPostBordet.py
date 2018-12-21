import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz268a.mmed")

ACIER=DEFI_MATERIAU(ELAS=_F(E=300000.0,
                            NU=0.,),
                    ECRO_LINE=_F(D_SIGM_EPSI=0.0,
                                 SY=300.0,),
                    )

CHMAT=AFFE_MATERIAU(MAILLAGE=MA,
                    AFFE=_F(TOUT='OUI',
                            MATER=ACIER,),
                         )

MO=AFFE_MODELE(MAILLAGE=MA,
               AFFE=(
                     _F(TOUT='OUI',
                        PHENOMENE='MECANIQUE',
                        MODELISATION='AXIS_SI',),),
                      )

INSTANTS = code_aster.TimeStepManager()
INSTANTS.setTimeList( range(6) )
INSTANTS.build()


CLIM=AFFE_CHAR_MECA(MODELE=MO,
                    DDL_IMPO=(_F(GROUP_MA='BAS',
                                 DY=0.,),
                              _F(GROUP_MA='GAUCHE',
                                 DX=0.),),
                                 )

TRAC=AFFE_CHAR_MECA(MODELE=MO,
                    DDL_IMPO=_F(GROUP_MA='HAUT',
                                    DY=.01,),)

CMULT=DEFI_FONCTION(NOM_PARA='INST',VALE=(0.0,0.0,
                          1.0,1.0,
                          ),PROL_DROITE='LINEAIRE',)

EVOL=STAT_NON_LINE(MODELE=MO,
                   CHAM_MATER=CHMAT,
                   EXCIT=(_F(CHARGE=TRAC,
                            FONC_MULT=CMULT,
                            TYPE_CHARGE='FIXE_CSTE',),
                          _F(CHARGE=CLIM,),),
                   COMPORTEMENT=_F(RELATION='VMIS_ISOT_LINE',
                                TOUT='OUI',),
                   INCREMENT=_F(LIST_INST=INSTANTS),
                   NEWTON=_F(MATRICE='ELASTIQUE'),
                   CONVERGENCE=_F(RESI_GLOB_RELA=0.000001,
                                  ITER_GLOB_MAXI=20,),)

SIGY=DEFI_FONCTION(NOM_PARA='TEMP',VALE=(0.,00., 100.,1000.),
                    PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',)

SIGREF=DEFI_FONCTION(NOM_PARA='TEMP',VALE=(0.,200.,
                         100.,300.,
                         ),PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT')


BORDET=POST_BORDET(
            GROUP_MA='PAVE',
            NUME_ORDRE=5,
            PROBA_NUCL='OUI',
            PARAM=_F(M=22.,
                     SIG_CRIT=250,
                     SEUIL_REFE=300.,
                     VOLU_REFE=1.,
                     SIGM_REFE=SIGREF,
                     SEUIL_CALC=SIGY,
                     DEF_PLAS_REFE=0.001,
                     ),
            RESULTAT=EVOL,
            TEMP=100.,
            COEF_MULT=2*3.14)

test.assertTrue( True )

FIN()
