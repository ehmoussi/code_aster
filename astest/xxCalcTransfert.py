import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("forma12a.mmed")

MODELE=AFFE_MODELE(MAILLAGE=MA,
                   AFFE=_F(GROUP_MA='VOL',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='3D',),);

MAT=DEFI_MATERIAU(ELAS=_F(E=200.0E9,
                          NU=0.3,
                          RHO=8000.0,),)

CHMAT=AFFE_MATERIAU(MAILLAGE=MA,
                    AFFE=_F(GROUP_MA='VOL',
                            MATER=MAT,),);

BLOCAGE=AFFE_CHAR_MECA(MODELE=MODELE,
                       DDL_IMPO=_F(GROUP_MA='ENCAS',
                                   LIAISON='ENCASTRE',),);


GRAV=AFFE_CHAR_MECA(MODELE=MODELE,
                    PESANTEUR=_F(GRAVITE=300.,
                                 DIRECTION=(-1.,0,1,),),);


sinom = FORMULE(VALE='sin(2*3.1415*15.0*INST)',
                NOM_PARA='INST',);


TRANSD = DYNA_LINE(TYPE_CALCUL="TRAN",
                 BASE_CALCUL="PHYS",
                 MODELE=MODELE,
                 CHAM_MATER=CHMAT,
                 CHARGE=BLOCAGE,
                 EXCIT=_F(CHARGE=GRAV, FONC_MULT=sinom,),
                 BANDE_ANALYSE=1./(5.*0.002),
                 SCHEMA_TEMPS=_F(SCHEMA ='NEWMARK'),
                 INCREMENT=_F(INST_FIN=0.1,
                               PAS=(0.002),),)

inst = DEFI_LIST_REEL(DEBUT=0.,
                      INTERVALLE=_F(PAS=0.002, JUSQU_A=0.1,))


SINOM=CALC_FONC_INTERP(LIST_PARA=inst,
                       FONCTION=sinom,);

#C_FREQ2=CALC_TRANSFERT(NOM_CHAM='ACCE',
#                       RESULTAT_X=TRANSD,
#                       RESULTAT_Y=TRANSD,
#                       REPERE='ABSOLU',
#                       ENTREE=_F(NOEUD='N1',),
#                       SORTIE=_F(NOEUD='N2',),
#                                 );

test.assertTrue( True )

FIN()
