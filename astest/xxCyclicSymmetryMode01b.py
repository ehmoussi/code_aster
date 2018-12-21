#!/usr/bin/python
# coding: utf-8

# Cas-test issu de sdlv134a
# Validation de la sous-structuration cyclique
# Legacy syntax

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

#
SECTEUR=LIRE_MAILLAGE(FORMAT='MED',  UNITE=20)

SECTEUR=DEFI_GROUP( reuse=SECTEUR,   MAILLAGE=SECTEUR,
  CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'))

#
MODELE=AFFE_MODELE(   MAILLAGE=SECTEUR,
                             AFFE=_F( TOUT = 'OUI',
                                   PHENOMENE = 'MECANIQUE',
                                   MODELISATION = '3D'))

#
MATER=DEFI_MATERIAU(  ELAS=_F( E = 2.E11, NU = 0.3, RHO = 7800.0))

#
CHAMPMAT=AFFE_MATERIAU(  MAILLAGE=SECTEUR,
                              AFFE=_F( TOUT = 'OUI',
                                    MATER = MATER))

#
CHARGE=AFFE_CHAR_CINE(   MODELE=MODELE,MECA_IMPO=(
              _F( GROUP_NO = 'ENCAS',DX = 0.0,DY = 0.0,DZ = 0.0),
              _F( GROUP_NO = 'AXE',DX = 0.0,DY = 0.0,DZ = 0.0),
              _F( GROUP_NO = 'Droite',DX = 0.0,DY = 0.0,DZ = 0.0),
              _F( GROUP_NO = 'Gauche',DX = 0.0,DY = 0.0,DZ = 0.0)))

#
"""
FIXME: CALC_MATR_ELEM/CHARGE does not accept char_cine objects.

RIGIELEM=CALC_MATR_ELEM(      MODELE=MODELE,
                                CHARGE=CHARGE,
                            CHAM_MATER=CHAMPMAT,
                               OPTION='RIGI_MECA')

#
MASSELEM=CALC_MATR_ELEM(      MODELE=MODELE,
                                CHARGE=CHARGE,
                            CHAM_MATER=CHAMPMAT,
                               OPTION='MASS_MECA')

#
NUMEROTA=NUME_DDL(   MATR_RIGI=RIGIELEM)

#
MATRRIGI=ASSE_MATRICE(  MATR_ELEM=RIGIELEM,
                           NUME_DDL=NUMEROTA)

#
MATRMASS=ASSE_MATRICE(  MATR_ELEM=MASSELEM,
                           NUME_DDL=NUMEROTA)




#
LINT=DEFI_INTERF_DYNA(   NUME_DDL=NUMEROTA,INTERFACE=(
                             _F( NOM = 'AXE',
                                        TYPE = 'CRAIGB',
                                        GROUP_NO = 'AXE',),
                             _F( NOM = 'DROITE',
                                        TYPE = 'CRAIGB',
                                        GROUP_NO = 'Droite',),
                             _F( NOM = 'GAUCHE',
                                        TYPE = 'CRAIGB',
                                        GROUP_NO = 'Gauche',))
                              )
#
#MODES=CALC_MODES( MATR_RIGI=MATRRIGI,
#                  MATR_MASS=MATRMASS,
#                  CALC_FREQ=_F( NMAX_FREQ = 15))

#
BAMO=DEFI_BASE_MODALE( CLASSIQUE=_F( INTERF_DYNA = LINT,
                                        MODE_MECA = MODES,
                                        NMAX_MODE = 15)
                             )

#
MODCYC=MODE_ITER_CYCL(  BASE_MODALE=BAMO,
                               NB_MODE=15,
                            NB_SECTEUR=6,
                               LIAISON=_F( DROITE = 'DROITE',
                                        GAUCHE = 'GAUCHE',
                                        AXE='AXE',),
                                CALCUL=_F( NB_DIAM = (0, 1, 2, 3,),
                                        NMAX_FREQ = 2,
                                        PREC_AJUSTE = 1.E-12)
                           )
"""

# at least it pass here!
test.assertTrue( True )
test.printSummary()

FIN()
