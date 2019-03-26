import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAYAFE0 = code_aster.Mesh()
MAYAFE0.readAsterMeshFile("sdls112a.20")

MAYAFE0=DEFI_GROUP(reuse =MAYAFE0,
                   MAILLAGE=MAYAFE0,
                   CREA_GROUP_MA=_F(NOM='ALL_EL',
                                    TOUT='OUI',),
                   CREA_GROUP_NO=_F(TOUT_GROUP_MA='OUI',),);

MATER1=DEFI_MATERIAU(ELAS=_F(E=72000000000.0,
                             NU=0.34,
                             RHO=2700.0,),);

MATER2=DEFI_MATERIAU(ELAS=_F(E=210000000000.0,
                             NU=0.29,
                             RHO=7800.0,),);

MAYAFEM=CREA_MAILLAGE(MAILLAGE=MAYAFE0,
    CREA_POI1=(
        _F(NOM_GROUP_MA='GROUP10', GROUP_NO = 'GROUP10', ),
    ),
)

MODFEM=AFFE_MODELE(MAILLAGE=MAYAFEM,
                   AFFE=(_F(GROUP_MA=('GROUP1','GROUP2','GROUP3','GROUP4','GROUP5','GROUP6','GROUP7','GROUP8',),
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DKT',),
                         _F(GROUP_MA='GROUP9',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DIS_TR',),
                         _F(GROUP_MA='GROUP10',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DIS_T',),),);

CHMAT=AFFE_MATERIAU(MAILLAGE=MAYAFEM,
                    AFFE=(_F(GROUP_MA=('GROUP1','GROUP2','GROUP3','GROUP4','GROUP5','GROUP6','GROUP7','GROUP9',),
                             MATER=MATER1,),
                          _F(GROUP_MA='GROUP8',
                             MATER=MATER2,),),);

CHCAR=AFFE_CARA_ELEM(MODELE=MODFEM,
                     COQUE=(_F(GROUP_MA=('GROUP2','GROUP3','GROUP4','GROUP5','GROUP7',),
                               EPAIS=0.01,),
                            _F(GROUP_MA='GROUP8',
                               EPAIS=0.016,),
                            _F(GROUP_MA='GROUP1',
                               EPAIS=0.05,),
                            _F(GROUP_MA='GROUP6',
                               EPAIS=0.011,),),
                     DISCRET=(_F(GROUP_MA='GROUP9',
                                 REPERE='GLOBAL',
                                 CARA='K_TR_D_L',
                                 VALE=(1e+12,1e+12,1e+12,100000000.0,100000000.0,100000000.0,),),
                                _F(GROUP_MA='GROUP9',
                                 REPERE='GLOBAL',
                                 CARA='M_TR_L',
                                 VALE=(0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,
                                 0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,
                                 0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,
                                 0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,),),
                              _F(GROUP_MA='GROUP10',
                                 CARA='M_T_D_N',
                                 VALE=0.5,),),);


CHARGE=AFFE_CHAR_MECA(MODELE=MODFEM,
                      DDL_IMPO=_F(NOEUD='N58',
                                  DX=0.0,
                                  DY=0.0,
                                  DZ=0.0,
                                  DRX=0.0,
                                  DRY=0.0,
                                  DRZ=0.0,),);

KELEM=CALC_MATR_ELEM(OPTION='RIGI_MECA',
                     MODELE=MODFEM,
                     CHAM_MATER=CHMAT,
                     CARA_ELEM=CHCAR,
                     CHARGE=CHARGE,
                     );

MELEM=CALC_MATR_ELEM(OPTION='MASS_MECA',
                     MODELE=MODFEM,
                     CHAM_MATER=CHMAT,
                     CARA_ELEM=CHCAR,
                     CHARGE=CHARGE,
                     );

NUME=NUME_DDL(MATR_RIGI=KELEM,);

KASS=ASSE_MATRICE(MATR_ELEM=KELEM,
                  NUME_DDL=NUME,);

MASS=ASSE_MATRICE(MATR_ELEM=MELEM,
                  NUME_DDL=NUME,);

MASSE=POST_ELEM(MASS_INER=_F(TOUT='OUI',),
                MODELE=MODFEM,
                CHAM_MATER=CHMAT,
                CARA_ELEM=CHCAR,);

l_noeud = (124,137,144,142,112,103,12,
           9,1,25,34,62,63,43,94,77,88,90,85)


noeuds = [ 'N'+ str(kk) for kk in l_noeud]
nb_noeuds = len(noeuds)
nb_ddl = nb_noeuds*3

DEFI_GROUP(reuse=MAYAFEM, MAILLAGE=MAYAFEM, CREA_GROUP_NO=_F(NOM='group_no', NOEUD=noeuds))

CHSTAT = AFFE_CHAR_MECA( MODELE=MODFEM,
                         DDL_IMPO=_F(NOEUD=noeuds,
                                     DX=0.0,DY=0.0,DZ=0.0,),);

KELSTAT = CALC_MATR_ELEM( OPTION='RIGI_MECA',
                          MODELE=MODFEM,
                          CHAM_MATER=CHMAT,
                          CARA_ELEM=CHCAR,
                          CHARGE=CHSTAT
                          );

NUMSTAT = NUME_DDL( MATR_RIGI = KELSTAT,);

KASTAT = ASSE_MATRICE( MATR_ELEM=KELSTAT,
                       NUME_DDL=NUMSTAT,);


MODSTAT = MODE_STATIQUE( MATR_RIGI = KASTAT,
                         MODE_STAT = _F(GROUP_NO = 'group_no',
                                        AVEC_CMP = ('DX','DY','DZ')))

MAYAtmp=LIRE_MAILLAGE(FORMAT="ASTER",UNITE=22);

MAYAtmp=DEFI_GROUP(reuse =MAYAtmp,
                   MAILLAGE=MAYAtmp,
                   CREA_GROUP_MA=_F(NOM='ALL_EXP',
                                    TOUT='OUI',),
                   CREA_GROUP_NO=_F(TOUT_GROUP_MA='OUI',),);


MAYAEXP=CREA_MAILLAGE(MAILLAGE=MAYAtmp,
                      TITRE='         AUTEUR=INTERFACE_IDEAS                 ',
                      CREA_POI1=_F(TOUT='OUI',NOM_GROUP_MA='NOEU'),
                      )


MODEXP=AFFE_MODELE(MAILLAGE=MAYAEXP,
                   AFFE=_F(GROUP_MA='NOEU',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='DIS_T',),);

CHCAREXP=AFFE_CARA_ELEM(MODELE=MODEXP,
                     DISCRET=(_F(GROUP_MA='NOEU',
                                 REPERE='GLOBAL',
                                 CARA='K_T_D_N',
                                 VALE=(1e+12,1e+12,1e+12,),
                                ),
                              _F(GROUP_MA='NOEU',
                                 REPERE='GLOBAL',
                                 CARA='M_T_D_N',
                                 VALE=(0.,),
                                ),));

KELEXP=CALC_MATR_ELEM(OPTION='RIGI_MECA',
                     MODELE=MODEXP,
                     CARA_ELEM=CHCAREXP,
                     );

MELEXP=CALC_MATR_ELEM(OPTION='MASS_MECA',
                     MODELE=MODEXP,
                     CARA_ELEM=CHCAREXP,
                     );


NUMEXP=NUME_DDL(MATR_RIGI=KELEXP );

KASSEXP=ASSE_MATRICE(MATR_ELEM=KELEXP, NUME_DDL=NUMEXP,);

MASSEXP=ASSE_MATRICE(MATR_ELEM=MELEXP, NUME_DDL=NUMEXP,);

MODMES=LIRE_RESU(TYPE_RESU='MODE_MECA',
                 FORMAT='IDEAS',
                 MODELE=MODEXP,
                 UNITE=21,
                 NOM_CHAM='DEPL',
                 MATR_RIGI =KASSEXP,
                 MATR_MASS =MASSEXP,
                 FORMAT_IDEAS=_F(NOM_CHAM='DEPL',
                                 NUME_DATASET=55,
                                 RECORD_6=(1,2,3,8,2,6,),
                                 POSI_ORDRE=(7,4,),
                                 POSI_NUME_MODE=(7,4),
                                 POSI_FREQ=(8,1,),
                                 POSI_MASS_GENE=(8,2),
                                 POSI_AMOR_GENE=(8,3),
                                 NOM_CMP=('DX','DY','DZ','DRX','DRY','DRZ'),),
                 TOUT_ORDRE='OUI',);

MACRO_EXPANS( MODELE_CALCUL = _F(MODELE = MODFEM,
                                 BASE = MODSTAT,
                                 NUME_ORDRE = list(range(1,nb_ddl+1))),
              MODELE_MESURE = _F(MODELE  = MODEXP,
                                 MESURE  = MODMES,),
              NUME_DDL      = NUMEXP,
              RESU_ET       = CO("RES_MODE"),
              RESU_RD       = CO("RED_MODE"),
              RESOLUTION    = _F(METHODE='SVD'),
             );

test.assertTrue( True )

FIN()
