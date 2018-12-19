import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

PRE_IDEAS(   UNITE_IDEAS=18,  UNITE_MAILLAGE=22 )

MAILPLEX=LIRE_MAILLAGE(FORMAT="ASTER",UNITE=22  )


MAILPLEX=DEFI_GROUP( reuse=MAILPLEX,   MAILLAGE=MAILPLEX,
  CREA_GROUP_MA=_F(  NOM = 'TOUTPL', TOUT = 'OUI'))

MAILAST=LIRE_MAILLAGE(FORMAT='MED',)

MAILAST=DEFI_GROUP( reuse=MAILAST,   MAILLAGE=MAILAST,
  CREA_GROUP_MA=_F(  NOM = 'TOUTAST', TOUT = 'OUI'))

MODAST=AFFE_MODELE(   MAILLAGE=MAILAST,AFFE=(
                        _F(  TOUT = 'OUI', PHENOMENE = 'MECANIQUE',
                                          MODELISATION = 'DKT'),
                        _F(  GROUP_MA = ('DA', 'BC',), PHENOMENE = 'MECANIQUE',
                                                MODELISATION = 'POU_D_E'))
                      )

PRESPLEX=LIRE_PLEXUS(          UNITE=18,
                                 FORMAT='IDEAS',
                            MAIL_PLEXUS=MAILPLEX,
                               MAILLAGE=MAILAST,
                                 MODELE=MODAST,
                             TOUT_ORDRE='OUI',
                                  TITRE='PREMIER ESSAI LIRE_PLEXUS'
                        )

test.assertTrue( True )

FIN()
