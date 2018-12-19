import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ssls124d.21")

YG=2.E11
L=100.
b=10.
F=1.

MAT=DEFI_MATERIAU(ELAS=_F(E=YG,
                          NU=0.3,),);
h=10.

MA=MODI_MAILLAGE(reuse=MA,MAILLAGE=MA,
ORIE_SHB=_F(GROUP_MA='GEOTOT'),)

MAIL31=DEFI_GROUP(reuse =MA, MAILLAGE=MA,
                CREA_GROUP_NO=(_F(GROUP_MA='SUENCAS',),
                               _F(GROUP_MA='SUDEPIM',),
                               _F(GROUP_MA='LI15',),
                               _F(GROUP_MA='LI21',),
                               _F(GROUP_MA='LI87',),),);

CHMAT31=AFFE_MATERIAU(MAILLAGE=MA,
                  AFFE=_F(TOUT='OUI',MATER=MAT,),);

MODMEC31=AFFE_MODELE(MAILLAGE=MA,
                    AFFE=_F(TOUT='OUI',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='SHB',),);


CHARG31=AFFE_CHAR_MECA(MODELE=MODMEC31,
                      DDL_IMPO=(_F(GROUP_MA=('SUENCAS'),
                                   DX=0.0,),
                                _F(GROUP_MA='LI15',
                                   DY=0.0,),
                                _F(GROUP_MA='LI21',
                                   DZ=0.0,),),
                      FORCE_ARETE=(_F(GROUP_MA='LI87',
                                      FZ=F/b,),),
                           );

RESU31=MECA_STATIQUE(MODELE=MODMEC31,
                    CHAM_MATER=CHMAT31,
                    EXCIT=_F(CHARGE=CHARG31,),
                    );

RESU31=CALC_CHAMP(reuse=RESU31,
                  RESULTAT=RESU31,
                  CRITERES=('SIEQ_ELGA','SIEQ_ELNO'),
                  CONTRAINTE=('SIEF_ELNO','SIGM_ELNO'),);

ENGENDRE_TEST(CO=RESU31,TYPE_TEST='SOMM_ABS')

test.assertTrue( True )

FIN()
