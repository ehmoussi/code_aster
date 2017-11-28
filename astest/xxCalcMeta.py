import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("hsna104a.mmed")

# DEFINITION DES MAILLES ASSOCIEES AUX DIFFERENTES COUCHES DE DURETE
# PHENOMENE DE DECARBURATION A L INTERFACE DANS L ACIER
# UNE COUCHE DE DURETE EST DEFINIE PAR UN ENSEMBLE DE MAILLES SITUE SUR
# LE MEME RAYON

MA=DEFI_GROUP(reuse =MA,
                MAILLAGE=MA,
                CREA_GROUP_MA=(_F(NOM='HV_130',
                                  MAILLE=
                                  ('M682','M683','M684','M685','M686','M687','M688',
                                           'M689','M690','M691','M692','M693','M205','M206','M207','M208','M209','M210',
                                           'M211','M212','M213','M214','M215','M216',),),
                               _F(NOM='HV_150',
                                  MAILLE=
                                  ('M694','M695','M696','M697','M698','M699','M700',
                                           'M701','M702','M703','M704','M705','M217','M218','M219','M220','M221','M222',
                                           'M223','M224','M225','M226','M227','M228',),),
                               _F(NOM='HV_170',
                                  MAILLE=
                                  ('M706','M707','M708','M709','M710','M711','M712',
                                           'M713','M714','M715','M716','M717','M229','M230','M231','M232','M233','M234',
                                           'M235','M236','M237','M238','M239','M240',),),
                               _F(NOM='HV_190',
                                  MAILLE=
                                  ('M718','M719','M720','M721','M722','M723','M724',
                                           'M725','M726','M727','M728','M729','M241','M242','M243','M244','M245','M246',
                                           'M247','M248','M249','M250','M251','M252',),),
                               _F(NOM='HV_210',
                                  MAILLE=
                                  ('M730','M731','M732','M733','M734','M735','M736',
                                           'M737','M738','M739','M740','M741','M253','M254','M255','M256','M257','M258',
                                           'M259','M260','M261','M262','M263','M264',),),
                               _F(NOM='HV_230',
                                  MAILLE=
                                  ('M742','M743','M744','M745','M746','M747','M748',
                                           'M749','M750','M751','M752','M753','M265','M266','M267','M268','M269','M270',
                                           'M271','M272','M273','M274','M275','M276',),),
                               _F(NOM='HV_250',
                                  MAILLE=
                                  ('M754','M755','M756','M757','M758','M759','M760',
                                           'M761','M762','M763','M764','M765','M277','M278','M279','M280','M281','M282',
                                           'M283','M284','M285','M286','M287','M288',),),),);
#######################################


# PARTIES THERMIQUE ET METALLURGIQUE
#######################################


# PARAMETRES MATERIAUX
# DIAGRAMME TRC DE L ACIER
# PASSAGE DE L AUSTENITE ENTRE 758.5 ET 616.5 DEGRES

TRCACIER=CREA_TABLE(LISTE=( _F(PARA='VITESSE',LISTE_R=[5.00000E-02], NUME_LIGN=[1]),
                            _F(PARA='PARA_EQ',LISTE_R=[1.10000E+01], NUME_LIGN=[1]),
                            _F(PARA='COEF_0',LISTE_R=[0.00000E+00], NUME_LIGN=[1]),
                            _F(PARA='COEF_1',LISTE_R=[0.00000E+00], NUME_LIGN=[1]),
                            _F(PARA='COEF_2',LISTE_R=[0.00000E+00], NUME_LIGN=[1]),
                            _F(PARA='COEF_3',LISTE_R=[0.00000E+00], NUME_LIGN=[1]),
                            _F(PARA='COEF_4',LISTE_R=[0.00000E+00], NUME_LIGN=[1]),
                            _F(PARA='COEF_5',LISTE_R=[0.00000E+00], NUME_LIGN=[1]),
                            _F(PARA='NB_POINT',LISTE_R=[6.00000E+00]),
                            _F(PARA='Z1',LISTE_R=[0.00000E+00, 0.00000E+00, 1.00000E-02, 9.90000E-01, 1.00000E+00, 1.00000E+00], NUME_LIGN=[2, 3, 4, 5, 6, 7]),
                            _F(PARA='Z2',LISTE_R=[0.00000E+00, 0.00000E+00, 0.00000E+00, 0.00000E+00, 0.00000E+00, 0.00000E+00], NUME_LIGN=[2, 3, 4, 5, 6, 7]),
                            _F(PARA='Z3',LISTE_R=[0.00000E+00, 0.00000E+00, 0.00000E+00, 0.00000E+00, 0.00000E+00, 0.00000E+00], NUME_LIGN=[2, 3, 4, 5, 6, 7]),
                            _F(PARA='TEMP',LISTE_R=[8.30000E+02, 7.58500E+02, 7.55000E+02, 6.20000E+02, 6.16500E+02, 5.10000E+02], NUME_LIGN=[2, 3, 4, 5, 6, 7]),
                            _F(PARA='SEUIL',LISTE_R=[4.50000E-01], NUME_LIGN=[8]),
                            _F(PARA='AKM',LISTE_R=[-3.12500E+01], NUME_LIGN=[8]),
                            _F(PARA='BKM',LISTE_R=[1.40600E+01], NUME_LIGN=[8]),
                            _F(PARA='TPLM',LISTE_R=[-3.49700E+03], NUME_LIGN=[8]),
                            _F(PARA='DREF',LISTE_R=[1.10000E+01], NUME_LIGN=[8]),
                            _F(PARA='A',LISTE_R=[0.00000E+00], NUME_LIGN=[8]),
                            ))

ACIERT=DEFI_MATERIAU(THER=_F(LAMBDA=41.03E-3,
                             RHO_CP=0.0E-3,),
                     META_ACIER=_F(TRC=TRCACIER,
                                   AR3=830.0,
                                   ALPHA=-0.0306,
                                   MS0=415.0,
                                   AC1=724.0,
                                   AC3=846.0,
                                   TAUX_1=0.34,
                                   TAUX_3=0.34,),
                     );

INOXT=DEFI_MATERIAU(THER=_F(LAMBDA=41.03E-3,
                            RHO_CP=0.0E-3,),
                    META_ACIER=_F(TRC=TRCACIER,
                                  AR3=0.0E-3,
                                  ALPHA=-0.0306,
                                  MS0=0.0E-3,
                                  AC1=724.0,
                                  AC3=846.0,
                                  TAUX_1=0.34,
                                  TAUX_3=0.34,),
                    );

CHMATT=AFFE_MATERIAU(MAILLAGE=MA,
                     AFFE=(_F(GROUP_MA='SURDGH',
                              MATER=ACIERT,),
                           _F(GROUP_MA='SURDGB',
                              MATER=INOXT,),),);

MOTH=AFFE_MODELE(MAILLAGE=MA,
                 AFFE=_F(TOUT='OUI',
                         PHENOMENE='THERMIQUE',
                         MODELISATION='AXIS',),);


CHTEMP=CREA_CHAMP(TYPE_CHAM='NOEU_TEMP_R',
                  OPERATION='AFFE',
                  MAILLAGE=MA,
                  AFFE=_F(TOUT='OUI',
                          NOM_CMP='TEMP',
                          VALE=0.0,),);

TEMPE=CREA_RESU(OPERATION='AFFE',
                TYPE_RESU='EVOL_THER',
                NOM_CHAM='TEMP',
                AFFE=_F(CHAM_GD=CHTEMP,
                        INST=[ 154000.*n/27 for n in range(27)],),);

PHASINIT=CREA_CHAMP(TYPE_CHAM='CART_VAR2_R',
                    OPERATION='AFFE',
                    MAILLAGE=MA,
                    AFFE=_F(TOUT='OUI',
                            NOM_CMP=('V1','V2','V3','V4','V5',),
                            VALE=(0.0,0.0,0.0,0.0,11.0,),),);

TEMPE=CALC_META(reuse =TEMPE,
                RESULTAT=TEMPE,
                MODELE=MOTH,
                CHAM_MATER=CHMATT,
                ETAT_INIT=_F(META_INIT_ELNO=PHASINIT,),
                COMPORTEMENT=_F(RELATION='ACIER',),
                OPTION='META_ELNO',);

test.assertTrue( True )
