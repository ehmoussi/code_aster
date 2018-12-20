import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("sdll148a.20")

MODELE=AFFE_MODELE(  MAILLAGE=MA,
                     AFFE=_F(  GROUP_MA = 'MC',
                               PHENOMENE = 'MECANIQUE',
                               MODELISATION = 'POU_D_T'))


CARA=AFFE_CARA_ELEM(MODELE=MODELE,
                    POUTRE=_F(GROUP_MA='MC',
                              SECTION='GENERALE',
                              CARA=('A','IY','IZ',
                                    'AY','AZ','JX',
                                    'RY','RZ','RT',),
                              VALE=(1.26737E-04,2.71577E-09,2.71577E-09,
                                    1.69403E+00,1.69403E+00,5.43155E-09,
                                    7.93900E-03,7.93900E-03,7.93900E-03,),),);

MAT=DEFI_MATERIAU(  ELAS=_F( E = 2.200000E+11,
                             RHO = 8.330000E+03,
                             NU = 3.000000E-01))

CHMAT=AFFE_MATERIAU(   MAILLAGE=MA,
                       AFFE=_F(  TOUT = 'OUI',
                                 MATER = MAT))

CHDDL=AFFE_CHAR_MECA(  MODELE=MODELE,
                       DDL_IMPO=(_F(  GROUP_NO = 'EXTREMIT',
                                      DX=0.0,DY=0.0,DZ=0.0,DRY=0.0),
                                 _F(  GROUP_NO = 'MC',
                                      DZ=0.0,)))

MELR=CALC_MATR_ELEM( MODELE=MODELE,
                     CHARGE=CHDDL,
                     CARA_ELEM=CARA,
                     CHAM_MATER=CHMAT,
                     OPTION='RIGI_MECA' )

MELM=CALC_MATR_ELEM( MODELE=MODELE,
                     CHARGE=CHDDL,
                     CARA_ELEM=CARA,
                     CHAM_MATER=CHMAT,
                     OPTION='MASS_MECA' )

NUM=NUME_DDL( MATR_RIGI=MELR )


MATRR=ASSE_MATRICE( MATR_ELEM=MELR,
                    NUME_DDL=NUM )

MATRM=ASSE_MATRICE( MATR_ELEM=MELM,
                     NUME_DDL=NUM )

MODES=CALC_MODES(MATR_RIGI=MATRR,
                 VERI_MODE=_F(STOP_ERREUR='NON',
                              STURM='NON',
                              ),
                 OPTION='PLUS_PETITE',
                 CALC_FREQ=_F(NMAX_FREQ=2,
                              ),
                 MATR_MASS=MATRM,
                 )

import numpy as NP
pi = NP.pi
SXX = FORMULE(NOM_PARA=('X1','Y1','Z1','X2','Y2','Z2','FREQ'),
              VALE_C='FREQ*sin(pi*Y1)*sin(pi*Y2)',)

INTESPEC=CREA_TABLE(LISTE=(_F(LISTE_K=(SXX.getName()),PARA='FONCTION_C'),
                           _F(LISTE_K=('DX'),PARA='NUME_ORDRE_I'),
                           _F(LISTE_K=('DX'),PARA='NUME_ORDRE_J'),),
                    TYPE_TABLE='TABLE_FONCTION',
                    TITRE='SPECTRE D EXCITATION SINUS');


SPECTRE1=DEFI_SPEC_TURB( SPEC_CORR_CONV_3=_F( TABLE_FONCTION = INTESPEC ),);


SPPROJ=PROJ_SPEC_BASE( SPEC_TURB=SPECTRE1,
                       MODELE_INTERFACE=MODELE,
                       GROUP_MA='BAS',
                       NB_POIN=2,
                       FREQ_INIT= 1 ,
                       FREQ_FIN= 2 ,
                       TOUT_CMP='NON',
                       MODE_MECA=MODES );

test.assertTrue( True )

FIN()
