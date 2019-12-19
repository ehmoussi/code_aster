import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("sslp02a.mmed")

MA=MODI_MAILLAGE(reuse =MA,
                 MAILLAGE=MA,
                 ORIE_PEAU_2D=_F(GROUP_MA='CD',),);

mod=AFFE_MODELE(MAILLAGE=MA,
                AFFE=_F(TOUT='OUI',
                        PHENOMENE='MECANIQUE',
                        MODELISATION='C_PLAN',),);

mater=DEFI_MATERIAU(ELAS=_F(E=3.e4,
                            NU=.25,),);

chmat=AFFE_MATERIAU(MODELE=mod,
                    AFFE=_F(TOUT='OUI',
                            MATER=mater,),);

Charge=AFFE_CHAR_MECA(MODELE=mod,
                      DDL_IMPO=(_F(GROUP_MA='AB',
                                   DY=0.,),
                                _F(GROUP_MA='DE',
                                   DX=0.,),),
                      FORCE_CONTOUR=_F(GROUP_MA='CD',
                                       FY=2.5,),);

RESU=MECA_STATIQUE(MODELE=mod,
                   CHAM_MATER=chmat,
                   EXCIT=_F(CHARGE=Charge,),
                   OPTION='SANS',);

RESU=CALC_CHAMP(reuse =RESU,
                RESULTAT=RESU,
                CONTRAINTE='SIGM_NOEU',);

RESU1=MODI_REPERE(
                  RESULTAT    = RESU,
                  MODI_CHAM  =  _F(NOM_CHAM   = 'SIGM_NOEU',
                                   NOM_CMP    = ('SIXX','SIYY','SIZZ','SIXY',),
                                   TYPE_CHAM  = 'TENS_2D',),
                   REPERE     = 'CYLINDRIQUE',
                   AFFE = _F(TOUT='OUI',
                             ORIGINE    = (0.0, 0.0)))

test.assertTrue( True )

FIN()
