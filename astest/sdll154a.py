# coding: utf-8
  
import code_aster
from code_aster.Commands import *
import numpy as np

DEBUT()

# maillage, modele, caraelem

maillage = code_aster.Mesh()
maillage.readMedFile("sdll154a.mmed")

modele = AFFE_MODELE(MAILLAGE = maillage,
                    AFFE = _F(MODELISATION = "POU_D_T",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",))

acier=DEFI_MATERIAU(ELAS=_F(E = 2.E11,
                            RHO = 7800,
                            ALPHA = 1.2E-5,
                            NU = 0.3),
                    RAMBERG_OSGOOD=_F(FACTEUR=0.01,
                                     EXPOSANT=2)
                    )


t_ini=CREA_CHAMP(
    TYPE_CHAM='NOEU_TEMP_R', OPERATION='AFFE', MODELE=modele,
    AFFE=_F(TOUT='OUI', NOM_CMP='TEMP', VALE=20,),)

t_final=CREA_CHAMP(
                            TYPE_CHAM='NOEU_TEMP_R', OPERATION='AFFE', MODELE=modele,
                            AFFE=_F(TOUT='OUI', NOM_CMP='TEMP', VALE=120.0,),)

resu_temp = CREA_RESU(TYPE_RESU = 'EVOL_THER',
                        NOM_CHAM='TEMP',
                        OPERATION='AFFE',
                        AFFE=(
                            _F(CHAM_GD=t_ini, INST=0.0),
                            _F(CHAM_GD=t_final, INST=1.0),))


ch_mater=AFFE_MATERIAU(MAILLAGE=maillage,
                       AFFE_VARC=_F(TOUT='OUI',NOM_VARC = 'TEMP',EVOL=resu_temp,VALE_REF=20.0,),
                       AFFE=_F(TOUT="OUI", MATER = acier))

cara_elem=AFFE_CARA_ELEM(MODELE=modele, INFO=2,
                         POUTRE=_F(GROUP_MA="TUYAU", SECTION = 'CERCLE',
                                   CARA = ('R', 'EP'),
                                   VALE = (0.01, 0.005)))

# conditions aux limites

blocage_a = AFFE_CHAR_MECA(MODELE=modele,
                           DDL_IMPO=(_F(GROUP_NO='A',
                                        DX=0,DY=0,DZ=0,DRX=0, DRY=0, DRZ=0)))

blocage_b = AFFE_CHAR_MECA(MODELE=modele,
                           DDL_IMPO=(_F(GROUP_NO='B',
                                        DX=0, DZ=0)))

deplacement_b = AFFE_CHAR_MECA(MODELE=modele,
                               DDL_IMPO=(_F(GROUP_NO='B',
                                               DRX=0.02,)))

poids = AFFE_CHAR_MECA(MODELE=modele,
                       PESANTEUR=_F(GRAVITE=9.81,DIRECTION=( 0., 0., -1.),)
                       )

acce_xy=DEFI_FONCTION(NOM_PARA='FREQ',    INTERPOL='LOG',
                      VALE=(1.0, 1.962, 10.0, 19.62,
                            30.0,  19.62,   100.0,    1.962,
                            10000.0,   1.962,          )       )
spect_xy=DEFI_NAPPE(NOM_PARA='AMOR',
                    INTERPOL=('LIN', 'LOG'),
                    PARA=(0.015, 0.02, 0.025,),
                    FONCTION=(acce_xy, acce_xy, acce_xy))

# modes

ASSEMBLAGE(MODELE=modele,
           CHAM_MATER=ch_mater,
           CARA_ELEM=cara_elem,
           CHARGE=(blocage_a, blocage_b),
           NUME_DDL=CO('nddl'),
           MATR_ASSE=(_F(MATRICE=CO('matrice_rigi'),
                         OPTION='RIGI_MECA',),
                      _F(MATRICE=CO('matrice_mass'),
                         OPTION='MASS_MECA',),),);

modes_dyn=CALC_MODES(MATR_RIGI=matrice_rigi,
                     MATR_MASS=matrice_mass,
                     CALC_FREQ=_F(NMAX_FREQ=4),
                     )
modes_dyn=CALC_CHAMP(reuse=modes_dyn,
                     RESULTAT=modes_dyn,
                     CONTRAINTE='EFGE_ELNO')

modes_sta=MODE_STATIQUE(MATR_RIGI=matrice_rigi,
                        MATR_MASS=matrice_mass,
                        PSEUDO_MODE=_F(  AXE = ( 'X',  'Y',  'Z', )))
modes_sta=CALC_CHAMP(reuse=modes_sta,
                     RESULTAT=modes_sta,
                     CONTRAINTE='EFGE_ELNO')

# resultats

poids_propre = MECA_STATIQUE(MODELE=modele,
                             CHAM_MATER=ch_mater,
                             CARA_ELEM=cara_elem,
                             EXCIT=(_F(CHARGE=blocage_a),
                                    _F(CHARGE=poids)),
                             INST = 0.0)
poids_propre = CALC_CHAMP(reuse=poids_propre,
                            RESULTAT=poids_propre,
                            CONTRAINTE='EFGE_ELNO')

deplacement_impose = MECA_STATIQUE(MODELE=modele,
                                   CHAM_MATER=ch_mater,
                                   CARA_ELEM=cara_elem,
                                   EXCIT=(_F(CHARGE=blocage_a),
                                           _F(CHARGE=deplacement_b)),
                                   INST = 0.0)
deplacement_impose = CALC_CHAMP(reuse=deplacement_impose,
                                RESULTAT=deplacement_impose,
                                CONTRAINTE='EFGE_ELNO')

# IMPR_RESU(UNITE=6, FORMAT='RESULTAT', RESU=_F(RESULTAT=deplacement_impose, NOM_CHAM='EFGE_ELNO'))


tabInteg = POST_ELEM(MODELE=modele,
                     RESULTAT=deplacement_impose,
                     NUME_ORDRE=1, 
                     INTEGRALE=_F(NOM_CHAM = 'EFGE_ELNO',
                                  NOM_CMP='MT',
                                  TYPE_MAILLE = '1D',
                                  TOUT='OUI',
                                  ))

# IMPR_TABLE(UNITE=6, TABLE= tabInteg)

TEST_TABLE(REFERENCE='ANALYTIQUE',
           VALE_CALC=22.655716251849473,
           VALE_REFE=2*1.13278581259247E+01,
           NOM_PARA='INTE_MT',
           TABLE=tabInteg,
           FILTRE=_F(NOM_PARA='NUME_ORDRE',
                     VALE_I=1,),
           )

dilatation_thermique = MECA_STATIQUE(MODELE=modele,
                                     CHAM_MATER=ch_mater,
                                     CARA_ELEM=cara_elem,
                                     EXCIT=(_F(CHARGE=blocage_a,),
                                            _F(CHARGE=blocage_b,)),
                                     INST = 1.0)
dilatation_thermique = CALC_CHAMP(reuse=dilatation_thermique,
                                  RESULTAT=dilatation_thermique,
                                  CONTRAINTE='EFGE_ELNO')

sismique = COMB_SISM_MODAL(MODE_MECA=modes_dyn,
                           AMOR_REDUIT=0.02,
                           CORR_FREQ='NON',
                           MODE_CORR=modes_sta,
                           MONO_APPUI = 'OUI',
                           EXCIT=_F( TRI_SPEC = 'OUI',
                                     SPEC_OSCI = ( spect_xy,  spect_xy, spect_xy, ),
                           ECHELLE = ( 1.,  1.,  0.5, )),
                           COMB_MODE=_F(  TYPE = 'SRSS'),
                           COMB_DIRECTION=_F(  TYPE = 'QUAD'),
                           OPTION=('EFGE_ELNO')
                          )

# calcul des references pour POST_ROCHE, on extrait uniquement les valeurs de MT, MFY et MFZ non nulles

table = CREA_TABLE(RESU=_F(RESULTAT=poids_propre,
                            NOM_CHAM="EFGE_ELNO",
                            TOUT="OUI",
                            NOM_CMP=("MT", "MFY", "MFZ")))
poids_propre_values = table.EXTR_TABLE().values()
mfy_poids_propre = np.array(poids_propre_values["MFY"])

table = CREA_TABLE(RESU=_F(RESULTAT=deplacement_impose,
                            NOM_CHAM="EFGE_ELNO",
                            TOUT="OUI",
                            NOM_CMP=("MT", "MFY", "MFZ")))
deplacement_impose_values = table.EXTR_TABLE().values()
mt_deplacement_impose = np.array(deplacement_impose_values["MT"])

table = CREA_TABLE(RESU=_F(RESULTAT=dilatation_thermique,
                            NOM_CHAM="EFGE_ELNO",
                            TOUT="OUI",
                            NOM_CMP=("MT", "MFY", "MFZ")))
dilatation_thermique_values = table.EXTR_TABLE().values()

table = CREA_TABLE(RESU=_F(RESULTAT=sismique,
                            NUME_ORDRE=14,
                            NOM_CHAM="EFGE_ELNO",
                            TOUT="OUI",
                            NOM_CMP=("MT", "MFY", "MFZ")))
sismique_dyn_values = table.EXTR_TABLE().values()
mfy_sismique_dyn = np.array(sismique_dyn_values["MFY"])
mfz_sismique_dyn = np.array(sismique_dyn_values["MFZ"])

table = CREA_TABLE(RESU=_F(RESULTAT=sismique,
                            NUME_ORDRE=24,
                            NOM_CHAM="EFGE_ELNO",
                            TOUT="OUI",
                            NOM_CMP=("MT", "MFY", "MFZ")))
sismique_qs_values = table.EXTR_TABLE().values()
mfy_sismique_qs = np.array(sismique_qs_values["MFY"])
mfz_sismique_qs = np.array(sismique_qs_values["MFZ"])

from sdll154a_fonctions import PostRocheAnalytic
post_roche_analytic = PostRocheAnalytic(mfy_poids_propre, mt_deplacement_impose, mfy_sismique_dyn, mfz_sismique_dyn, mfy_sismique_qs, mfz_sismique_qs)
post_roche_analytic.calcul_ressort()
post_roche_analytic.calcul_abattement()
post_roche_analytic.calcul_sigma_eq()

# appel à POST_ROCHE

chPostRocheTout = POST_ROCHE(ZONE_ANALYSEE=(_F(
                                     TOUT='OUI',
                                     GROUP_NO_ORIG = 'A',
                                    ),
                                  ),
                    RESU_MECA=(
                               _F(TYPE_CHAR='POIDS',
                                 RESULTAT=poids_propre,
                                 NUME_ORDRE=1,
                                 ),
                               _F(TYPE_CHAR='DILAT_THERM',
                                 RESULTAT=dilatation_thermique,
                                 NUME_ORDRE=1,
                                 ),
                               _F(TYPE_CHAR='DEPLACEMENT',
                                 RESULTAT=deplacement_impose,
                                 NUME_ORDRE=1,
                                 ),
                                _F(TYPE_CHAR='SISM_INER_SPEC',
                                 RESULTAT=sismique,
                                 DIRECTION='COMBI',
                                 ),
                                ),
                     PRESSION=(_F(
                                     TOUT='OUI',
                                     VALE = 1E6,
                                    ),
                                  ),
                    )

IMPR_RESU(UNITE=6, FORMAT='RESULTAT', 
           RESU=_F(CHAM_GD=chPostRocheTout, 
                   NOM_CMP=('X1','X2','X3','X4','X5','X6',
                            'X7','X8','X9','X10','X11','X12',
                            'X13','X14','X15','X16','X17','X18','X19','X20')))

chPostRocheGrMa = POST_ROCHE(ZONE_ANALYSEE=(_F(
                                     GROUP_MA='TUYAU',
                                     GROUP_NO_ORIG = 'A',
                                    ),
                                  ),
                    RESU_MECA=(
                               _F(TYPE_CHAR='POIDS',
                                 RESULTAT=poids_propre,
                                 NUME_ORDRE=1,
                                 ),
                               _F(TYPE_CHAR='DILAT_THERM',
                                 RESULTAT=dilatation_thermique,
                                 NUME_ORDRE=1,
                                 ),
                               _F(TYPE_CHAR='DEPLACEMENT',
                                 RESULTAT=deplacement_impose,
                                 NUME_ORDRE=1,
                                 ),
                                _F(TYPE_CHAR='SISM_INER_SPEC',
                                 RESULTAT=sismique,
                                 DIRECTION='COMBI',
                                 ),
                                ),
                     PRESSION=(_F(
                                     GROUP_MA='TUYAU',
                                     VALE = 1E6,
                                    ),
                                  ),
                    )

# TEST_RESU

TEST_RESU(CHAM_ELEM=(
                     # X15 = contrainte équivalente
                     _F(MAILLE='M1',
                        POINT=1,
                        REFERENCE="ANALYTIQUE",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X15',
                        VALE_CALC=29148813.041733082,
                        VALE_REFE=post_roche_analytic._sigma_eq[0]),
                     _F(MAILLE='M1',
                        POINT=2,
                        REFERENCE="ANALYTIQUE",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X15',
                        VALE_CALC=10185687.028488198,
                        VALE_REFE=post_roche_analytic._sigma_eq[1]),
                     _F(MAILLE='M2',
                        POINT=1,
                        REFERENCE="ANALYTIQUE",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X15',
                        VALE_CALC=10185687.028488223,
                        VALE_REFE=post_roche_analytic._sigma_eq[2]),
                     _F(MAILLE='M2',
                        POINT=2,
                        REFERENCE="ANALYTIQUE",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X15',
                        VALE_CALC=4185425.596891385,
                        VALE_REFE=post_roche_analytic._sigma_eq[3]),
                     # X16 = contrainte équivalente optimisée
                     _F(MAILLE='M1',
                        POINT=1,
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X16',
                        VALE_CALC=30529848.998718902),
                     _F(MAILLE='M1',
                        POINT=2,
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X16',
                        VALE_CALC=10185687.028488198),
                     _F(MAILLE='M2',
                        POINT=1,
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X16',
                        VALE_CALC=10185687.02848823),
                     _F(MAILLE='M2',
                        POINT=2,
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X16',
                        VALE_CALC=4185425.596891385),
                )
        )


FIN()
