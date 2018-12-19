# coding=utf-8
import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

mesh=code_aster.Mesh()
mesh.readMedFile("zzzz395e.mmed")


mesh=MODI_MAILLAGE(reuse =mesh,
                   MAILLAGE=mesh,
                   ORIE_PEAU_3D=_F(GROUP_MA='S_e',),);

# Define the material
steel=DEFI_MATERIAU(
          ELAS=     _F(E= 210000., NU = 0.3),
          ECRO_LINE=_F(D_SIGM_EPSI=100., SY=100.,),
          )

chmat=AFFE_MATERIAU(MAILLAGE=mesh,
                    AFFE=_F(TOUT='OUI',
                            MATER=steel,),);
# Mechanic model
model=AFFE_MODELE(MAILLAGE=mesh,
               AFFE=_F(TOUT='OUI',
                       PHENOMENE='MECANIQUE',
                       MODELISATION='3D',),);

# Boundary condition
chg_b=AFFE_CHAR_CINE(MODELE=model,
                      MECA_IMPO=_F(GROUP_MA='S_inf',
                                 DX=0,DY=0.0,DZ=0),
                     );

chg_p=AFFE_CHAR_MECA(MODELE=model,
                     PRES_REP=_F(GROUP_MA='S_e',
                                 PRES = 1000,),
                    )

# Time discretization
list_t=DEFI_LIST_REEL(DEBUT=0.0,
                      INTERVALLE=_F(JUSQU_A=10.0,
                                    PAS=1.0,),);

list_i=DEFI_LIST_INST(METHODE='MANUEL',
                      DEFI_LIST=_F(LIST_INST=list_t,),);

rampe=DEFI_FONCTION(NOM_PARA='INST',VALE=(0.0,0.0,
                                          10.,1.,
                   ),);

# Complete computation to create base
stnl=STAT_NON_LINE(MODELE=model,
                   CHAM_MATER=chmat,
                   EXCIT=(_F(CHARGE=chg_b,),
                          _F(CHARGE=chg_p,FONC_MULT=rampe),
                         ),
                   INCREMENT=_F(LIST_INST=list_i,),
                   COMPORTEMENT=_F(RELATION='VMIS_ISOT_LINE',),)

stnl=CALC_CHAMP(reuse=stnl,
                RESULTAT=stnl,
                CONTRAINTE='SIEF_NOEU',);

# Create base (DEPL)
base_p=DEFI_BASE_REDUITE(RESULTAT = stnl,
                         INFO     = 2,
                         NOM_CHAM = 'DEPL',
                         TOLE_SVD = 1.E-3,);

# Create base (SIEF_NOEU)
base_d=DEFI_BASE_REDUITE(RESULTAT = stnl,
                         INFO     = 2,
                         NOM_CHAM = 'SIEF_NOEU',
                         TOLE_SVD = 1.E-3,);

test.assertEqual(base_p.getType(), "MODE_EMPI")
test.assertEqual(base_d.getType(), "MODE_EMPI")

# Tests
TEST_RESU(RESU=(
                _F(RESULTAT=base_p,
                   NUME_ORDRE= 1,
                   NOM_CHAM='DEPL',
                   NOEUD='N27',
                   NOM_CMP='DX',
                   VALE_CALC=-0.0257251188973,
                   ),
                _F(RESULTAT=base_p,
                   NUME_ORDRE= 1,
                   NOM_CHAM='DEPL',
                   NOEUD='N27',
                   NOM_CMP='DY',
                   VALE_CALC=-0.0734358940147,
                   ),
                _F(RESULTAT=base_p,
                   NUME_ORDRE= 1,
                   NOM_CHAM='DEPL',
                   NOEUD='N27',
                   NOM_CMP='DZ',
                   VALE_CALC=-0.195501268186,
                   ),
                _F(RESULTAT=base_p,
                   NUME_ORDRE= 2,
                   NOM_CHAM='DEPL',
                   NOEUD='N27',
                   NOM_CMP='DX',
                   VALE_CALC=-0.000562278273951,
                   ),
                _F(RESULTAT=base_p,
                   NUME_ORDRE= 2,
                   NOM_CHAM='DEPL',
                   NOEUD='N27',
                   NOM_CMP='DY',
                   VALE_CALC=0.00520149316886,
                   ),
                _F(RESULTAT=base_p,
                   NUME_ORDRE= 2,
                   NOM_CHAM='DEPL',
                   NOEUD='N27',
                   NOM_CMP='DZ',
                   VALE_CALC=-0.0201730121515,
                   ),
                ),
          );

TEST_RESU(RESU=(
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 1,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIXX',
                   VALE_CALC=0.0283450264009,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 1,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIYY',
                   VALE_CALC=0.0283170359222,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 1,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIZZ',
                   VALE_CALC=0.0266137782934,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 1,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIXY',
                   VALE_CALC=1.75375613041E-05,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 1,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIXZ',
                   VALE_CALC=-4.48907682761E-07,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 1,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIYZ',
                   VALE_CALC=-1.63604564979E-05,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 3,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIXX',
                   VALE_CALC=-0.0734894457675,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 3,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIYY',
                   VALE_CALC=-0.0751650710199,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 3,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIZZ',
                   VALE_CALC=-0.00124382365447,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 3,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIXY',
                   VALE_CALC=0.00155980842728,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 3,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIXZ',
                   VALE_CALC=0.000187281727054,
                   ),
                _F(RESULTAT=base_d,
                   NUME_ORDRE= 3,
                   NOM_CHAM='SIEF_NOEU',
                   NOEUD='N27',
                   NOM_CMP='SIYZ',
                   VALE_CALC=0.00153482671155,
                   ),
                ),
          );

test.printSummary()

FIN()
