# coding: utf-8
  
import code_aster
from code_aster.Commands import *

DEBUT()

# caracteristiques materiaux

B=1.4191e-20
Sy=133e6
m=8.0362
Young=176500000000.0
Rho=9734.

n=1/m
K=B*(Young/1.e6)**(1/n)

# geometrie

Dext=0.1143
hc=0.0135

# maillage, modele, caraelem

maillage = code_aster.Mesh()
maillage.readMedFile("sdll157a.mmed")

modele = AFFE_MODELE(MAILLAGE = maillage,
                    AFFE = _F(MODELISATION = "POU_D_T",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",))

acier=DEFI_MATERIAU(ELAS=_F(E = Young,
                            RHO = Rho,
                            ALPHA = 1.2E-5,
                            NU = 0.3),
                    RAMBERG_OSGOOD=_F(FACTEUR=K,
                                     EXPOSANT=n)
                    )

t_ini=CREA_CHAMP(TYPE_CHAM='NOEU_TEMP_R',
                 OPERATION='AFFE',
                 MODELE=modele,
                 AFFE=_F(TOUT='OUI',
                         NOM_CMP='TEMP',
                         VALE=20,),)

t_final=CREA_CHAMP(TYPE_CHAM='NOEU_TEMP_R',
                   OPERATION='AFFE',
                   MODELE=modele,
                   AFFE=_F(TOUT='OUI',
                           NOM_CMP='TEMP',
                           VALE=120.0,),)

resu_temp = CREA_RESU(TYPE_RESU = 'EVOL_THER',
                        NOM_CHAM='TEMP',
                        OPERATION='AFFE',
                        AFFE=(
                            _F(CHAM_GD=t_ini, INST=0.0),
                            _F(CHAM_GD=t_final, INST=1.0),))

ch_mater=AFFE_MATERIAU(MAILLAGE=maillage,
                       AFFE_VARC=_F(TOUT='OUI',
                                    NOM_VARC = 'TEMP',
                                    EVOL=resu_temp,
                                    VALE_REF=20.0,),
                       AFFE=_F(TOUT="OUI", MATER = acier))

cara_elem=AFFE_CARA_ELEM(MODELE=modele, INFO=2,
                         POUTRE=_F(GROUP_MA="tuyau", SECTION = 'CERCLE',
                                   CARA = ('R', 'EP'),
                                   VALE = (Dext/2, hc)))

# conditions aux limites

blocage = AFFE_CHAR_MECA(MODELE=modele,
                         DDL_IMPO=(_F(GROUP_NO=('ENCA1','ENCA2'),
                                      DX=0,DY=0,DZ=0,DRX=0, DRY=0, DRZ=0)))

# TODO : valeur des déplacements ? integrale de l'accelero pour calcul du déplacement et utilisation du déplacement max ?
deplacement = AFFE_CHAR_MECA(MODELE=modele,
                             DDL_IMPO=(_F(GROUP_NO='ENCA1',
                                          DX=0,DY=0,DZ=0,DRX=0, DRY=0, DRZ=0),
                                       _F(GROUP_NO='ENCA2',
                                          DX=0.01, DY=0.01, DZ=0.01)))

poids = AFFE_CHAR_MECA(MODELE=modele,
                       PESANTEUR=_F(GRAVITE=9.81,DIRECTION=( 0., 0., -1.),)
                       )

spectre02=LIRE_FONCTION(UNITE=21,
                        NOM_PARA='FREQ', INTERPOL='LOG',
                        PROL_GAUCHE='CONSTANT',
                        PROL_DROITE='CONSTANT',);

sro02=DEFI_NAPPE(NOM_PARA='AMOR',
                 PARA=0.02,
                 FONCTION=spectre02)

# modes

ASSEMBLAGE(MODELE=modele,
           CHAM_MATER=ch_mater,
           CARA_ELEM=cara_elem,
           CHARGE=blocage,
           NUME_DDL=CO('nddl'),
           MATR_ASSE=(_F(MATRICE=CO('matrice_rigi'),
                         OPTION='RIGI_MECA',),
                      _F(MATRICE=CO('matrice_mass'),
                         OPTION='MASS_MECA',),),);
modes_dyn=CALC_MODES(OPTION='BANDE',
                     MATR_RIGI=matrice_rigi,
                     MATR_MASS=matrice_mass,
                     CALC_FREQ=_F(FREQ=(0.0,100.0,),),)
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
                             EXCIT=(_F(CHARGE=blocage),
                                    _F(CHARGE=poids)),
                             INST = 0.0)
poids_propre = CALC_CHAMP(reuse=poids_propre,
                            RESULTAT=poids_propre,
                            CONTRAINTE='EFGE_ELNO')

deplacement_impose = MECA_STATIQUE(MODELE=modele,
                                   CHAM_MATER=ch_mater,
                                   CARA_ELEM=cara_elem,
                                   EXCIT=(_F(CHARGE=deplacement)),
                                   INST = 0.0)
deplacement_impose = CALC_CHAMP(reuse=deplacement_impose,
                                RESULTAT=deplacement_impose,
                                CONTRAINTE='EFGE_ELNO')

dilatation_thermique = MECA_STATIQUE(MODELE=modele,
                                     CHAM_MATER=ch_mater,
                                     CARA_ELEM=cara_elem,
                                     EXCIT=(_F(CHARGE=blocage,)),
                                     INST = 1.0)
dilatation_thermique = CALC_CHAMP(reuse=dilatation_thermique,
                                  RESULTAT=dilatation_thermique,
                                  CONTRAINTE='EFGE_ELNO')

sismique = COMB_SISM_MODAL(MODE_MECA=modes_dyn,
                           AMOR_REDUIT=0.02,
                           CORR_FREQ='NON',
                           MODE_CORR=modes_sta,
                           MONO_APPUI = 'OUI',
                           EXCIT=_F(TRI_AXE=(1.,1.,1.),
                                    SPEC_OSCI=sro02,
                                    ECHELLE=90.09,),
                           COMB_MODE=_F(TYPE='CQC'),
                           COMB_DIRECTION=_F(TYPE='QUAD'),
                           OPTION=('EFGE_ELNO')
                          )

# appel à POST_ROCHE

chPostRocheTout = POST_ROCHE(ZONE_ANALYSEE=(_F(
                                     TOUT='OUI',
                                     GROUP_NO_ORIG = 'ENCA1',
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
                     COUDE=(_F(GROUP_MA = 'Arc_1',
                               ANGLE    = 90,
                               RCOURB   = 0.152,
                               SY       = Sy),
                            _F(GROUP_MA = 'Arc_2',
                               ANGLE    = 90,
                               RCOURB   = 0.152,
                               SY       = Sy),
                            _F(GROUP_MA = 'Arc_3',
                               ANGLE    = 90,
                               RCOURB   = 0.152,
                               SY       = Sy),
                            _F(GROUP_MA = 'Arc_4',
                               ANGLE    = 90,
                               RCOURB   = 0.152,
                               SY       = Sy),
                            _F(GROUP_MA = 'Arc_5',
                               ANGLE    = 90,
                               RCOURB   = 0.152,
                               SY       = Sy),
                            _F(GROUP_MA = 'Arc_6',
                               ANGLE    = 90,
                               RCOURB   = 0.152,
                               SY       = Sy),
                           )
                    )

# TEST_RESU

TEST_RESU(CHAM_ELEM=(
                    # X1 = contrainte de référence
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X1',
                        VALE_CALC=51345567.86167478),
                    # X2 = contrainte de référence S2
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X2',
                        VALE_CALC=438043471.4142695),
                    # X3 = réversibilité locale t
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X3',
                        VALE_CALC=1206427238.0891001),
                    # X4 = réversibilité locale ts
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X4',
                        VALE_CALC=6.288279607881528),
                    # X5 = réversibilité totale T
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X5',
                        VALE_CALC=2338.144436667211),
                    # X6 = réversibilité totale Ts
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X6',
                        VALE_CALC=0.0006982580850394795),
                    # X7 = facteur d'effet de ressort r_M
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X7',
                        VALE_CALC=5.35433317228734),
                    # X8 = facteur d'effet de ressort r_S
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X8',
                        VALE_CALC=5.745545770638011),
                    # X9 = facteur d'effet de ressort maximal r_M_Max
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X9',
                        VALE_CALC=5.35433317228734),
                    # X10 = facteur d'effet de ressort maximal r_S_Max
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X10',
                        VALE_CALC=5.745545770638011),
                    # X11 = coefficient d'abattement g
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X11',
                        VALE_CALC=1.0),
                    # X12 = coefficient d'abattement gs
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X12',
                        VALE_CALC=0.9999871124380207),
                    # X13 = coefficient d'abattement optimisé gOpt
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X13',
                        VALE_CALC=0.8398268996182074),
                    # X14 = coefficient d'abattement optimisé gsOpt
                     _F(TYPE_TEST="MAX",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X14',
                        VALE_CALC=0.9999871124380207),
                    # X15 = contrainte équivalente
                     _F(TYPE_TEST="MAX",
                        REFERENCE="AUTRE_ASTER",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X15',
                        VALE_CALC=350425920.4053404,
                        PRECISION=0.5,
                        VALE_REFE=240.2e6),
                    # X16 = contrainte équivalente optimisée
                     _F(TYPE_TEST="MAX",
                        REFERENCE="AUTRE_ASTER",
                        CHAM_GD=chPostRocheTout,
                        NOM_CMP='X16',
                        VALE_CALC=349389994.531175,
                        PRECISION=0.5,
                        VALE_REFE=240.2e6),
                    )
        )

FIN()
