import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ssls126b.mmed")

MA=DEFI_GROUP(reuse =MA,
                MAILLAGE=MA,
                CREA_GROUP_NO=(_F(GROUP_MA='LCONTY',),
                               _F(GROUP_MA='LCONTX',),
                               _F(GROUP_MA='LSYMY',),
                               _F(GROUP_MA='LSYMX',),),);

MOD=AFFE_MODELE(MAILLAGE=MA,
                AFFE=_F(TOUT='OUI',
                        PHENOMENE='MECANIQUE',
                        MODELISATION='Q4GG',),);

MA=MODI_MAILLAGE(reuse =MA,
                   MAILLAGE=MA,
                   ORIE_NORM_COQUE=_F(GROUP_MA='DALLE',
                                      VECT_NORM=(0.0,0.0,1.0,),
                                      GROUP_NO='A1',),);

MAT=DEFI_MATERIAU(ELAS=_F(E=35700000000.0,
                          NU=0.0,),);

CHMAT=AFFE_MATERIAU(MAILLAGE=MA,
                    AFFE=_F(TOUT='OUI',
                            MATER=MAT,),);

CARA_ELE=AFFE_CARA_ELEM(MODELE=MOD,
                        COQUE=_F(GROUP_MA='MESH',
                                 EPAIS=0.12,
                                 ANGL_REP=(0.0,0.0,),),);

COND_LIM=AFFE_CHAR_MECA(MODELE=MOD,
                        DDL_IMPO=(_F(GROUP_NO='LCONTY',
                                     DZ=0.0,),
                                  _F(GROUP_NO='LSYMX',
                                     DY=0.0,
                                     DRX=0.0,),
                                  _F(GROUP_NO='LSYMY',
                                     DX=0.0,
                                     DRY=0.0,),),);

PRES=AFFE_CHAR_MECA(MODELE=MOD,
                    FORCE_COQUE=_F(GROUP_MA='DALLE',
                                   PRES=-10000.0,),);

CH_FO=DEFI_FONCTION(
                    NOM_PARA='INST',
                    VALE=(0.0 ,0.0 ,
                          1.0 ,1.0 ,),
                    PROL_DROITE='LINEAIRE',
                    PROL_GAUCHE='LINEAIRE',);

INST = code_aster.TimeStepManager()
INST.setTimeList( [0., 0.5, 1.0] )
INST.build()

RESU=STAT_NON_LINE(MODELE=MOD,
                   CHAM_MATER=CHMAT,
                   CARA_ELEM=CARA_ELE,
                   EXCIT=(_F(CHARGE=COND_LIM,),
                          _F(CHARGE=PRES,
                             FONC_MULT=CH_FO,),),
                   COMPORTEMENT=_F(RELATION='ELAS',),
                   INCREMENT=_F(LIST_INST=INST,),);

RESU=CALC_CHAMP(reuse =RESU,
                RESULTAT=RESU,
                CONTRAINTE=('EFGE_ELNO','EFGE_ELGA',),
                DEFORMATION=('DEGE_ELNO','DEGE_ELGA',),
                VARI_INTERNE='VARI_ELNO',);


tab2=POST_COQUE(RESULTAT=RESU,
                CHAM='EFFORT',
                INST=0.5,
                COOR_POINT=(_F(COOR=(0.5,0.5,0.0,),),
                            _F(COOR=(0.4,0.4,0.0,),),
                            _F(COOR=(0.3,0.3,0.0,),),
                            _F(COOR=(0.2,0.2,0.0,),),
                            _F(COOR=(0.1,0.1,0.0,),),),);

test.assertTrue( True )

FIN()
