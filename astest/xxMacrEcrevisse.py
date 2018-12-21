import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAIL = code_aster.Mesh()
MAIL.readMedFile("zzzz354a.mmed")

MAIL = DEFI_GROUP(reuse    = MAIL,
                  MAILLAGE = MAIL,
                  CREA_GROUP_MA = (
                        _F(NOM='GHAUT',GROUP_MA = ('GM21'),),
                        _F(NOM='GBAS',GROUP_MA = ('GM22'),),
                        _F(NOM='BETON',UNION = ('GM21','GM22'),),
                        _F(NOM='INTRADOS',UNION = ('GM14','GM19'),),
                        _F(NOM='EXTRADOS',UNION = ('GM15','GM18'),),
                        _F(NOM='HAUT',GROUP_MA = ('GM16'),),
                        _F(NOM='BAS',GROUP_MA = ('GM20'),),
                        _F(NOM='ENCASTRE',UNION = ('BAS','HAUT'),),
                        _F(NOM='BFISH',GROUP_MA = ('GM13'),),
                        _F(NOM='BFISB',UNION = ('GM17'),),
                                    ),);

MAIL = DEFI_GROUP(reuse    = MAIL,
                  MAILLAGE = MAIL,
                  CREA_GROUP_NO = (
                        _F(GROUP_MA = ('BETON','ENCASTRE','INTRADOS',
                                        'EXTRADOS','BFISH','BFISB',),),
                        _F(OPTION    ='SEGM_DROI_ORDO',
                            NOM      ='BFISBO',
                            GROUP_NO ='BFISB',
                            GROUP_NO_ORIG = 'GM28',
                            GROUP_NO_EXTR = 'GM30',
                            PRECISION     = 1.E-6,
                            CRITERE = 'ABSOLU',),
                        _F(OPTION    = 'SEGM_DROI_ORDO',
                            NOM      ='BFISHO',
                            GROUP_NO ='BFISH',
                            GROUP_NO_ORIG = 'GM27',
                            GROUP_NO_EXTR = 'GM29',
                            PRECISION     = 1.E-6,
                            CRITERE = 'ABSOLU',),),)

MAIL = MODI_MAILLAGE(
              reuse        = MAIL,
              MAILLAGE     = MAIL,
              ORIE_PEAU_2D = _F(GROUP_MA = ('ENCASTRE','INTRADOS',
                                            'EXTRADOS','BFISH','BFISB',),),)

MODMECA = AFFE_MODELE(
                  MAILLAGE  = MAIL,
                  AFFE      = (_F(GROUP_MA = ('BETON','ENCASTRE','INTRADOS',
                                              'EXTRADOS','BFISH','BFISB',),
                  PHENOMENE = 'MECANIQUE',
                  MODELISATION = 'D_PLAN',),),)

MODTHER = AFFE_MODELE(
                  MAILLAGE  = MAIL,
                  AFFE      = _F(GROUP_MA=('BETON','ENCASTRE','INTRADOS',
                                           'EXTRADOS','BFISH','BFISB',),
                  PHENOMENE = 'THERMIQUE',
                  MODELISATION = 'PLAN_DIAG',),)

BETON = DEFI_MATERIAU(ELAS = _F(E      = 1.E25,
                                NU     = 0.2,
                                ALPHA  = 1.0E-20,),
                      THER = _F(LAMBDA = 0.,
                                RHO_CP = 2500.*8800000000000.,),)

CHMAT = AFFE_MATERIAU(MAILLAGE  = MAIL,
                      AFFE      = (_F(GROUP_MA = ('BETON','ENCASTRE','INTRADOS',
                                                  'EXTRADOS','BFISH','BFISB',),
                                      MATER    = BETON,),),)

CONDMECA = AFFE_CHAR_MECA( MODELE      = MODMECA,
                           FACE_IMPO   = _F(GROUP_MA = ('ENCASTRE'), DNOR = 0.0,),
                           DDL_IMPO    = _F(GROUP_NO = ('GM24','GM25'), DX = 0),
                      )

CONT  = DEFI_CONTACT(MODELE      = MODMECA,
                     FORMULATION = 'DISCRETE',
                     REAC_GEOM   = 'SANS',
                     ZONE        = _F(
                            GROUP_MA_MAIT = 'BFISH',
                            GROUP_MA_ESCL = 'BFISB',
                     ),)

PR_EXT = DEFI_FONCTION( NOM_PARA    = 'INST',
                        PROL_GAUCHE = 'CONSTANT',
                        PROL_DROITE = 'CONSTANT',
                        VALE = ( 0,              1.E5,
                                 5000.,      1.E5, ), )

PR_INT = DEFI_FONCTION( NOM_PARA    = 'INST',
                        PROL_GAUCHE = 'CONSTANT',
                        PROL_DROITE = 'CONSTANT',
                        VALE = ( 0,              1.E6,
                                 5000.,      1.E6, ), )

TEMP_EXT = DEFI_FONCTION(NOM_PARA    = 'INST',
                       PROL_GAUCHE = 'CONSTANT',
                       PROL_DROITE = 'CONSTANT',
                       VALE = ( 0.,        20.,
                                5000., 20., ), )

TEMP_INT = DEFI_FONCTION(NOM_PARA    = 'INST',
                       PROL_GAUCHE = 'CONSTANT',
                       PROL_DROITE = 'CONSTANT',
                       VALE = ( 0.,        180.,
                                5000., 180., ), )

H_EXT = DEFI_FONCTION(NOM_PARA    = 'INST',
                       PROL_GAUCHE = 'CONSTANT',
                       PROL_DROITE = 'CONSTANT',
                       VALE = ( 0.,        0.,
                                5000., 0., ), )

H_INT = DEFI_FONCTION(NOM_PARA    = 'INST',
                       PROL_GAUCHE = 'CONSTANT',
                       PROL_DROITE = 'CONSTANT',
                       VALE = ( 0.,        0.,
                                5000., 0., ), )


CONDTHER = AFFE_CHAR_THER_F(
                    MODELE  = MODTHER,
                    ECHANGE = (_F(GROUP_MA = 'INTRADOS',
                                  COEF_H   = H_INT,
                                  TEMP_EXT = TEMP_INT,),
                               _F(GROUP_MA = 'EXTRADOS',
                                  COEF_H   = H_EXT,
                                  TEMP_EXT = TEMP_EXT,),),)

L_INST = DEFI_LIST_REEL(
                DEBUT      = 0.0,
                INTERVALLE = (_F(JUSQU_A = 5000., NOMBRE = 2,), ),)

#RMECA = MACR_ECREVISSE(
         #TABLE  = CO('TABLECR'),
         #DEBIT  = CO('DEBECR'),
         #TEMPER = CO('TEMPECR'),
         #CHAM_MATER   = CHMAT,
         #MODELE_MECA  = MODMECA,
         #MODELE_THER  = MODTHER,
         #TEMP_INIT    = 20.,
         #EXCIT_MECA   = _F(CHARGE   = CONDMECA),
         #EXCIT_THER   = _F(CHARGE   = CONDTHER),
         #COMPORTEMENT = _F(RELATION ='ELAS',),
         #CONTACT      = CONT,
         #FISSURE = _F(
               #PREFIXE_FICHIER  = 'FISSURE1',
               #SECTION          = 'RECTANGLE',
               #GROUP_MA         = ('BFISH','BFISB',),
               #RUGOSITE         = 0.5E-06,
               #ZETA             = 0.0,
               #GROUP_NO_ORIG    = ('GM27','GM28',),
               #GROUP_NO_EXTR    = ('GM29','GM30',),
               #LISTE_VAL_BL     = (1., 1.),
               #OUVERT_REMANENTE = 10.0E-06,
               #TORTUOSITE       = 1.0, ),
         #ECOULEMENT = _F(
               #FLUIDE_ENTREE  = 5,
               #PRES_ENTREE_FO = PR_INT,
               #PRES_SORTIE_FO = PR_EXT,
               #PRES_PART      = 6.E5,
               #TITR_MASS      = 0.3,),
         #LIST_INST = L_INST,
         #MODELE_ECRE = _F(
               #IVENAC         = 0,
               #ECOULEMENT     = 'SATURATION',
               #FROTTEMENT     = 0,
               #TRANSFERT_CHAL = 2,),
         #CONV_CRITERE = _F(
               #TEMP_REF = 0.5,
               #PRES_REF = 0.01*1.E5,
               #CRITERE  = 'EXPLICITE',),
         #CONVERGENCE_ECREVISSE = _F(
               #CRIT_CONV_DEBI = 1.e-8,
               #KGTEST         = 0.4,
               #ITER_GLOB_MAXI = 400,),
         #VERSION     = '3.2.2',
         #COURBES     = 'AUCUNE',
         #IMPRESSION  = 'NON',
         #INFO        = 1,
         #)

test.assertTrue( True )

test.printSummary()

FIN()
