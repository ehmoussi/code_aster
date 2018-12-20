import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ssls126a.mmed")

MA=DEFI_GROUP(reuse =MA,
                MAILLAGE=MA,
                CREA_GROUP_NO=(_F(GROUP_MA='LCONTY',),
                               _F(GROUP_MA='LCONTX',),
                               _F(GROUP_MA='LSYMY',),
                               _F(GROUP_MA='LSYMX',),),)

MOD=AFFE_MODELE(MAILLAGE=MA,
                AFFE=_F(TOUT='OUI',
                        PHENOMENE='MECANIQUE',
                        MODELISATION='Q4GG',),)

MAIL=MODI_MAILLAGE(reuse =MA,
                   MAILLAGE=MA,
                   ORIE_NORM_COQUE=_F(GROUP_MA='DALLE',
                                      VECT_NORM=(0.0,0.0,1.0,),
                                      GROUP_NO='A1',),)

MAT=DEFI_MATERIAU(ELAS=_F(E=35700000000.0,
                          NU=0.0,),)

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
INST.setTimeList( [0., 1., 2] )
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

RESU=CALC_FERRAILLAGE(reuse =RESU,
                      RESULTAT=RESU,
                      INST=1.0,
                      TYPE_COMB='ELU',
                      AFFE=_F(TOUT='OUI',
                              ENROBG=0.04,
                              SIGM_ACIER=500000000.0,
                              SIGM_BETON=21000000.0,
                              PIVA=0.01,
                              PIVB=0.0035,
                              ES=2.1e+11,),);


test.assertTrue( True )

FIN()
