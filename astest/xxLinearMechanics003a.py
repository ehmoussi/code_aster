#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

T=0.1

R=1.

P=1.

MATER=DEFI_MATERIAU(  ELAS=_F(  E = 1.,      NU = 0.3) )

MAILL=LIRE_MAILLAGE(FORMAT='MED'  )

DEFI_GROUP( reuse=MAILL,   MAILLAGE=MAILL,
                          CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'))

CHMAT=AFFE_MATERIAU(  MAILLAGE=MAILL,
                      AFFE=_F(  TOUT = 'OUI',   MATER = MATER) )

MODEL=AFFE_MODELE(  MAILLAGE=MAILL,    
                    AFFE=_F(  TOUT = 'OUI',   MODELISATION = 'DKT',
                              PHENOMENE = 'MECANIQUE') )

CHARGE=AFFE_CHAR_MECA(  MODELE=MODEL,
            DDL_IMPO=(_F( GROUP_NO = 'GRNO_ABC', DX = 0.,  DY = 0.,  DZ = 0.),
                      _F( GROUP_NO = 'GRNO_OA',  DY = 0.,  DRX = 0.,  DRZ = 0.),
                      _F( NOEUD = 'A',                 DRX = 0.,  DRZ = 0.),
                      _F( GROUP_NO = 'GRNO_OC',  DX = 0.,  DRY = 0.,  DRZ = 0.),
                      _F( NOEUD = 'C',                 DRY = 0.,  DRZ = 0.),
                      _F( NOEUD = 'O',           DX = 0.,  DY = 0.,
                                            DRX = 0.,  DRY = 0.,  DRZ = 0.)),
               FORCE_COQUE=_F(  TOUT = 'OUI', PRES = P) )

CARELEM=AFFE_CARA_ELEM(  MODELE=MODEL,
                         COQUE=_F(  GROUP_MA = 'TOUT', COQUE_NCOU=9,
                                    EPAIS = T,  ANGL_REP = (0., 0.,)))


RESU=MECA_STATIQUE(     MODELE=MODEL,
                    CHAM_MATER=CHMAT,
                     CARA_ELEM=CARELEM,
                       SOLVEUR=_F( STOP_SINGULIER = 'NON'),
                         EXCIT=_F(  CHARGE = CHARGE),
                       OPTION='SIEF_ELGA',                         
                             )

RESU.printMedFile("test.med")

MyFieldOnNodes = RESU.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()

test.assertAlmostEqual(sfon.getValue(5, 3), 971.7384412373856)

test.printSummary()

FIN()
