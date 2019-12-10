# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()
##
POUTRE=code_aster.Mesh()
POUTRE.readMedFile("sdll102a.mmed")

#
MODELE=AFFE_MODELE(   MAILLAGE=POUTRE,
                         AFFE=_F( TOUT = 'OUI', PHENOMENE = 'MECANIQUE',
                        MODELISATION = 'POU_D_E'))

#
MATER1=DEFI_MATERIAU(  ELAS=_F( E = 7.E10,  NU = 0.0,  RHO = 2700.))

#
MATER2=DEFI_MATERIAU(  ELAS=_F( E = 5.E10,  NU = 0.0,  RHO = 2500.))

#
MATER3=DEFI_MATERIAU(  ELAS=_F( E = 2.E11,  NU = 0.0,  RHO = 8000.))

#
CHAMPMAT=AFFE_MATERIAU(  MAILLAGE=POUTRE,AFFE=(
              _F( GROUP_MA = ('LI4','LI8',),MATER = MATER1),
              _F( GROUP_MA = ('LI3','LI7','LI11',),MATER = MATER1),
              _F( GROUP_MA = ('LI2','LI6','LI10',),MATER = MATER2),
              _F( GROUP_MA = ('LI1','LI5','LI9',),MATER = MATER3)))

#
CHAMPCAR=AFFE_CARA_ELEM(  MODELE=MODELE,POUTRE=(
            _F(  GROUP_MA = ('LI4','LI8',),  SECTION = 'CERCLE',
                          CARA = ('R','EP',), VALE = (6.055E-2,6.2E-3,)),
            _F(  GROUP_MA = 'LI1',  SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (1.2061E-2,2.3681E-5,2.3681E-5,4.7362E-5,  )),
            _F(  GROUP_MA = 'LI5',  SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (1.4621E-2,2.8709E-5,2.8709E-5,5.7418E-5,  )),
            _F(  GROUP_MA = 'LI9',  SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (1.5530E-2,3.0493E-5,3.0493E-5,6.0986E-5,  )),
            _F(  GROUP_MA = 'LI2',  SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (3.1428E-2,4.5070E-5,4.5070E-5,9.0140E-5,  )),
            _F(  GROUP_MA = 'LI6',  SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (3.2592E-2,4.6738E-5,4.6738E-5,9.3476E-5,  )),
            _F(  GROUP_MA = 'LI10', SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (3.3416E-2,4.7972E-5,4.7972E-5,9.5944E-5,  )),
            _F(  GROUP_MA = 'LI3',  SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (3.1944E-2,1.1500E-5,1.1500E-5,2.3000E-5,  )),
            _F(  GROUP_MA = 'LI7',  SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (4.2130E-2,1.1500E-5,1.1500E-5,2.3000E-5,  )),
            _F(  GROUP_MA = 'LI11', SECTION = 'GENERALE',
             CARA = ('A','IY','IZ','JX',),
             VALE = (3.1944E-2,1.1500E-5,1.1500E-5,2.3000E-5,  )))
                                                                   )

#
CHARGE=AFFE_CHAR_MECA(  MODELE=MODELE,
               FORCE_ELEC=_F( GROUP_MA = ('LI4','LI8',),
               POSITION = 'INFI',
               POINT1 = (0., 1., 4.395,), POINT2 = (1., 1., 4.395,)),LIAISON_DDL=(
              _F( NOEUD = ('N22','N125',),
              DDL = ('DY','DY',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N22','N125',),
              DDL = ('DZ','DZ',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N22','N125',),
              DDL = ('DRX','DRX',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N73','N127',),
              DDL = ('DX','DX',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N73','N127',),
              DDL = ('DY','DY',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N73','N127',),
              DDL = ('DZ','DZ',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N73','N127',),
              DDL = ('DRX','DRX',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N73','N127',),
              DDL = ('DRY','DRY',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N73','N127',),
              DDL = ('DRZ','DRZ',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N103','N126',),
              DDL = ('DY','DY',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N103','N126',),
              DDL = ('DZ','DZ',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.),
              _F( NOEUD = ('N103','N126',),
              DDL = ('DRX','DRX',),COEF_MULT = (1.,-1.,),COEF_IMPO = 0.)),
             DDL_IMPO=_F( GROUP_NO = ('P1','P5','P9',),DX = 0.0, DY = 0.0, DZ = 0.0,
                                          DRX = 0.0, DRY = 0., DRZ = 0.0))

RIGIELEM=CALC_MATR_ELEM(  MODELE=MODELE,  CHARGE=CHARGE,
                         CHAM_MATER=CHAMPMAT,  CARA_ELEM=CHAMPCAR,
                         OPTION='RIGI_MECA')

#
MASSELEM=CALC_MATR_ELEM(  MODELE=MODELE,  CHARGE=CHARGE,
                         CHAM_MATER=CHAMPMAT,  CARA_ELEM=CHAMPCAR,
                         OPTION='MASS_MECA')

#
VECTELEM=CALC_VECT_ELEM(   CHARGE=CHARGE,  CARA_ELEM=CHAMPCAR,
                          OPTION='CHAR_MECA')

#
NUMEROTA=NUME_DDL(   MATR_RIGI=RIGIELEM)

#
MATRRIGI=ASSE_MATRICE(  MATR_ELEM=RIGIELEM,  NUME_DDL=NUMEROTA)

#
MATRMASS=ASSE_MATRICE(  MATR_ELEM=MASSELEM,  NUME_DDL=NUMEROTA)

#
VECAS=ASSE_VECTEUR(   VECT_ELEM=VECTELEM,  NUME_DDL=NUMEROTA)

#
#

FONC=DEFI_FONC_ELEC(COUR=(
          _F(  INTE_CC_1 = 15600.,
                      TAU_CC_1 = 0.066, PHI_CC_1 = 0.,
                      INTE_CC_2 = 15600.,
                      TAU_CC_2 = 0.066, PHI_CC_2 = 180.,
                     INST_CC_INIT = 0., INST_CC_FIN = 0.135),
          _F(  INTE_CC_1 = 15600.,
                      TAU_CC_1 = 0.062, PHI_CC_1 = 0.,
                      INTE_CC_2 = 15600.,
                      TAU_CC_2 = 0.062, PHI_CC_2 = 180.,
                     INST_CC_INIT = 0.580, INST_CC_FIN = 0.885)))

test.assertEqual(FONC.getType(), "FONCTION_SDASTER")

#
#-----------------------------------------------------------------------
# EVOLUTIONS
NEWNONA=DYNA_VIBRA(TYPE_CALCUL='TRAN',BASE_CALCUL='PHYS',
                         MATR_MASS=MATRMASS,  MATR_RIGI=MATRRIGI,
                         SCHEMA_TEMPS=_F(SCHEMA='NEWMARK',),
                         INCREMENT=_F(PAS=0.0005, INST_INIT=0., INST_FIN=1.0),
                        ARCHIVAGE=_F(  INST = [j*0.01 for j in range(1, 101)] ),
                 EXCIT=_F(  VECT_ASSE = VECAS,
                         FONC_MULT = FONC)
                                                         )

# VERIFICATION   DEPLACEMENTS T = 0.12 ET 0.70
TEST_RESU(RESU=(_F(NUME_ORDRE=12,
                   RESULTAT=NEWNONA,
                   NOM_CHAM='DEPL',
                   NOEUD='N88',
                   NOM_CMP='DY',
                   VALE_CALC=-0.060491289184913,
                   VALE_REFE=-0.060499999999999998,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,
                   ),
                _F(NUME_ORDRE=70,
                   RESULTAT=NEWNONA,
                   NOM_CHAM='DEPL',
                   NOEUD='N88',
                   NOM_CMP='DY',
                   VALE_CALC=-0.11891578119383,
                   VALE_REFE=-0.11890000000000001,
                   REFERENCE = 'SOURCE_EXTERNE',
                   PRECISION=1.E-3,
                   ),
                ),
          )


test.printSummary()

FIN()
