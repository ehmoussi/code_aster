import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("sdll151a.mmed")

MODELE=AFFE_MODELE(MAILLAGE=MA,
                   AFFE=(_F(GROUP_MA='SUPPORT',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DKT'),
                         _F(GROUP_MA='VISCO',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='3D_SI'),
                         ),);

CARAPLAQ=AFFE_CARA_ELEM(MODELE=MODELE,
                        COQUE=_F(GROUP_MA='SUPPORT',
                                 EPAIS=1.E-3,
                                 EXCENTREMENT=0.5E-3,
                                 INER_ROTA='OUI'),
                        );


CONDLIM=AFFE_CHAR_MECA(MODELE=MODELE,
                       DDL_IMPO=_F(GROUP_MA='ENCAS',
                                   LIAISON='ENCASTRE',),);


list_f=DEFI_LIST_REEL(VALE=(1,10,50,100,500,1000,1500,),);

list_E=DEFI_LIST_REEL(VALE=(23.2E6,58.E6,145.E6,203.E6,348.E6,435.E6,464.E6,),);

list_eta=DEFI_LIST_REEL(VALE=(1.1,0.85,0.7,0.6,0.4,0.35,0.34,),);                            

fonc_E=DEFI_FONCTION(NOM_PARA='FREQ',
                     VALE_PARA=list_f,
                     VALE_FONC=list_E,
                     INTERPOL=('LIN','LIN',),
                     PROL_DROITE='LINEAIRE',
                     PROL_GAUCHE='CONSTANT',);

fonc_eta=DEFI_FONCTION(NOM_PARA='FREQ',
                       VALE_PARA=list_f,
                       VALE_FONC=list_eta,
                       INTERPOL=('LIN','LIN',),
                       PROL_DROITE='LINEAIRE',
                       PROL_GAUCHE='CONSTANT',);

modes=DYNA_VISCO(MODELE=MODELE,
                 CARA_ELEM=CARAPLAQ,
                 MATER_ELAS=_F(E=2.1e11,
                               NU=0.3,
                               RHO=7800.,
                               AMOR_HYST=0.001,
                               GROUP_MA='SUPPORT'),
                 MATER_ELAS_FO =_F(E=fonc_E,
                                   AMOR_HYST=fonc_eta,
                                   RHO=1200.,
                                   NU=0.45,
                                   GROUP_MA='VISCO'),
                 EXCIT=_F(CHARGE=CONDLIM),
                 FREQ=(1.,1500.),
                 RESI_RELA=1.e-4,
                 TYPE_RESU='MODE',
                 TYPE_MODE='COMPLEXE',
                 );

test.assertTrue( True )

FIN()
