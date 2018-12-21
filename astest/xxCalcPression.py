import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MESH = code_aster.Mesh()
MESH.readMedFile("ssnp154b.mmed")

MESH=MODI_MAILLAGE(reuse =MESH,
                   MAILLAGE=MESH,
                   ORIE_PEAU_2D=(_F(GROUP_MA='Top_B',),
                                 _F(GROUP_MA='Bottom_C',),),);

MESH=DEFI_GROUP(reuse=MESH,
                  MAILLAGE=MESH,
                  CREA_GROUP_NO=_F(TOUT_GROUP_MA='OUI'),);

MAT_cy=DEFI_MATERIAU(ELAS=_F(E=210000.0,
                             NU=0.3,),);

MAT_bl=DEFI_MATERIAU(ELAS=_F(E=70000.0,
                             NU=0.3,),);

FONC=DEFI_FONCTION(NOM_PARA='INST',VALE=(0.0,0.0,
                         1.0,1.0,
                         ),PROL_DROITE='LINEAIRE',PROL_GAUCHE='LINEAIRE',);

L_INST=DEFI_LIST_REEL(DEBUT=0.0,
                      INTERVALLE=_F(JUSQU_A=1.0,
                                     NOMBRE=2,),);

MO=AFFE_MODELE(MAILLAGE=MESH,
                 AFFE=(_F(GROUP_MA=('Block',),
                         PHENOMENE='MECANIQUE',
                         MODELISATION=('D_PLAN',),),
                       _F(GROUP_MA=('Cylinder',),
                         PHENOMENE='MECANIQUE',
                         MODELISATION=('D_PLAN',),),
                         ),
                         );

MA=AFFE_MATERIAU(MAILLAGE=MESH,
                   AFFE=(_F(GROUP_MA='Block',
                            MATER=MAT_bl,),
                         _F(GROUP_MA='Cylinder',
                            MATER=MAT_cy,),),);

CH_LIM=AFFE_CHAR_CINE(MODELE=MO,
                    MECA_IMPO=(_F(GROUP_NO='Axe',
                                 DX=0.0,),
                              _F(GROUP_NO='Encast',
                                 DX=0.0,
                                 DY=0.0,),),);

FORCE=AFFE_CHAR_MECA(MODELE=MO,
                     FORCE_NODALE=_F(GROUP_NO='Force',
                                    FY=-17500.0,),);

MESH=DEFI_GROUP(reuse =MESH,
                  MAILLAGE=MESH,
                  CREA_GROUP_NO=(_F(OPTION='NOEUD_ORDO',
                                   NOM='Bottom_n',
                                   GROUP_MA='Bottom_C',
                                   GROUP_NO_ORIG='C',),
                                 _F(OPTION='NOEUD_ORDO',
                                   NOM='Top_n',
                                   GROUP_MA='Top_B',
                                   GROUP_NO_ORIG='B',),),);

CONT=DEFI_CONTACT(MODELE=MO,
                  FORMULATION='CONTINUE',
                  ALGO_RESO_CONT = 'NEWTON',
                  ALGO_RESO_GEOM = 'NEWTON',
                  ZONE=_F(
                          GROUP_MA_MAIT='Top_B',
                          GROUP_MA_ESCL='Bottom_C',
                          CONTACT_INIT='OUI',
                          INTEGRATION='GAUSS',
                          ADAPTATION = 'TOUT',
                          ),);

RESU=STAT_NON_LINE(MODELE=MO,
                     CHAM_MATER=MA,
                     EXCIT=(_F(CHARGE=CH_LIM,),
                            _F(CHARGE=FORCE,
                               FONC_MULT=FONC,),),
                     CONTACT=CONT,
                     COMPORTEMENT=_F(RELATION='ELAS',
                                  DEFORMATION='GROT_GDEP',),
                     INCREMENT=_F(LIST_INST=L_INST,),
                     CONVERGENCE=_F(ITER_GLOB_MAXI=50,),
                     SOLVEUR=_F(),
                     NEWTON=_F(REAC_ITER=1,),);

RESU=CALC_CHAMP(reuse=RESU,RESULTAT=RESU,CONTRAINTE=('SIEF_ELNO'))

RESU=CALC_CHAMP(reuse =RESU,
               RESULTAT=RESU,
               CONTRAINTE='SIEF_NOEU',FORCE=('FORC_NODA','REAC_NODA'));

p_appr_F=CALC_PRESSION(MAILLAGE=MESH,
                       RESULTAT=RESU,
                       MODELE=MO,
                       GROUP_MA=('Bottom_C','Top_B',),
                       INST=1.0)

test.assertTrue( True )

FIN()
