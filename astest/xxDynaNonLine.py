import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz254a.mmed")

MATER=DEFI_MATERIAU(ELAS=_F(E=30000.0,
                            NU=0.2,
                            RHO=2764.0))

CHMAT=AFFE_MATERIAU(MAILLAGE=MA,
                    AFFE=_F(TOUT='OUI',
                            MATER=MATER,),);

MODELE=AFFE_MODELE(MAILLAGE=MA,
                   AFFE=_F(TOUT='OUI',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='3D',),);

CL=AFFE_CHAR_MECA(MODELE=MODELE,
                  DDL_IMPO=(_F(GROUP_NO='CENTER',
                               LIAISON='ENCASTRE',),
                            _F(GROUP_MA='BAS',
                               DZ=0.0,),
                            _F(GROUP_MA='CLDX',
                               DX=0.0,),
                            _F(GROUP_MA='CLDY',
                               DY=0.0,),),);

TRACTION=AFFE_CHAR_MECA(MODELE=MODELE,
                        FORCE_FACE=_F(GROUP_MA='HAUT',
                                      FZ=100.0,),);

INSTANT = code_aster.TimeStepManager()
INSTANT.setTimeList( [ 0.1* n/100 for n in range(101)] )
INSTANT.build()


FONCMULT=DEFI_FONCTION(NOM_PARA='INST',VALE=(0.0,1.0,
                             1.0,1.0,
                             ),PROL_DROITE='LINEAIRE',PROL_GAUCHE='LINEAIRE',);

ACCE0 = CREA_CHAMP(TYPE_CHAM='NOEU_DEPL_R',OPERATION='AFFE',MODELE=MODELE,
                   AFFE=_F(TOUT='OUI',
                           NOM_CMP=('DX', 'DY', 'DZ', 'EPXX', 'EPYY', 'EPZZ', 'EPXY', 'EPXZ', 'EPYZ',),
                           VALE = (0., 0., 0., 0., 0., 0., 0., 0., 0.,),),);


RESU=DYNA_NON_LINE(MODELE=MODELE,
                   CHAM_MATER=CHMAT,
                   ETAT_INIT=_F(ACCE=ACCE0),
                   EXCIT=(_F(CHARGE=CL,),
                          _F(CHARGE=TRACTION,
                             FONC_MULT=FONCMULT,),),
                   COMPORTEMENT=_F(RELATION='ELAS',),
                   INCREMENT=_F(LIST_INST=INSTANT,),
                   SCHEMA_TEMPS=_F(SCHEMA='NEWMARK',
                                   FORMULATION='DEPLACEMENT',),)

test.assertTrue( True )

FIN()
