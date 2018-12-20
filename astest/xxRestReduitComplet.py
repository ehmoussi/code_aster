import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

mesh = code_aster.Mesh()
mesh.readMedFile("zzzz395e.mmed")

mesh=MODI_MAILLAGE(reuse =mesh,
                   MAILLAGE=mesh,
                   ORIE_PEAU_3D=_F(GROUP_MA='S_e',),);

steel=DEFI_MATERIAU(
          ELAS=     _F(E= 210000., NU = 0.3),
          ECRO_LINE=_F(D_SIGM_EPSI=100., SY=100.,),
          )

chmat=AFFE_MATERIAU(MAILLAGE=mesh,
                    AFFE=_F(TOUT='OUI',
                            MATER=steel,),);
model=AFFE_MODELE(MAILLAGE=mesh,
               AFFE=_F(TOUT='OUI',
                       PHENOMENE='MECANIQUE',
                       MODELISATION='3D',),);

chg_b=AFFE_CHAR_CINE(MODELE=model,
                      MECA_IMPO=_F(GROUP_MA='S_inf',
                                 DX=0,DY=0.0,DZ=0),
                     );

chg_p=AFFE_CHAR_MECA(MODELE=model,
                     PRES_REP=_F(GROUP_MA='S_e',
                                 PRES = 1000,),
                    )

list_t=DEFI_LIST_REEL(DEBUT=0.0,
                      INTERVALLE=_F(JUSQU_A=10.0,
                                    PAS=1.0,),);

list_i=DEFI_LIST_INST(METHODE='MANUEL', 
                      DEFI_LIST=_F(LIST_INST=list_t,),);

rampe=DEFI_FONCTION(NOM_PARA='INST',VALE=(0.0,0.0,
                                          10.,1.,
                   ),);

base_p=LIRE_RESU(TYPE_RESU  = 'MODE_EMPI',
                 FORMAT     = 'MED',
                 MODELE     = model,
                 UNITE      = 70,
                 FORMAT_MED =_F(NOM_CHAM_MED = 'base_p__DEPL',
                                NOM_CHAM     = 'DEPL',),
                 TOUT_ORDRE = 'OUI',);


redu=STAT_NON_LINE(MODELE=model,
                   CHAM_MATER=chmat,
                   EXCIT=(_F(CHARGE=chg_b,),
                          _F(CHARGE=chg_p,FONC_MULT=rampe),
                         ),
                   INCREMENT=_F(LIST_INST=list_i,),
                    METHODE='MODELE_REDUIT',
                   MODELE_REDUIT=_F(
                    REAC_ITER=1,
                    BASE_PRIMAL     = base_p,
                    DOMAINE_REDUIT  = 'NON',
                    ),
                   COMPORTEMENT=_F(RELATION='VMIS_ISOT_LINE',),)


reduR = REST_REDUIT_COMPLET(
    MODELE           = model,
    RESULTAT_REDUIT  = redu, 
    BASE_PRIMAL      = base_p,
    REST_DUAL        = 'NON',
    INFO             = 2,)

test.assertTrue( True )

FIN()
