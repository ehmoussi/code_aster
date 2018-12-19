import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readAsterMeshFile("sslv109a.mail")

MO=AFFE_MODELE(  MAILLAGE=MA,
                         AFFE=_F(  TOUT = 'OUI',
                                PHENOMENE = 'MECANIQUE',
                                MODELISATION = 'AXIS_FOURIER',  ) )

MAT=DEFI_MATERIAU( ELAS=_F(  E = 72.,   NU = 0.3,   RHO = 0.,  ) )

P=DEFI_FONCTION(      NOM_PARA='X',
           VALE=(0.,0., .5, .5, 1., 1.,) )

U0=DEFI_FONCTION(      NOM_PARA='X',
           VALE=(0.,0., 1., 0.,) )

CM=AFFE_MATERIAU(  MAILLAGE=MA,
                           AFFE=_F(  TOUT = 'OUI',   MATER = MAT,  ) )

BLOQU=AFFE_CHAR_MECA_F(       MODELE=MO,DDL_IMPO=(
               _F(  NOEUD = 'N1',           DX = U0,   DY = U0,    DZ = U0,   ),
                        _F(  NOEUD = 'N2',           DY = U0,   ),
                        _F(  NOEUD = 'N3',           DY = U0,   ))   )

CH=AFFE_CHAR_MECA_F(       MODELE=MO,
               PRES_REP=_F(  GROUP_MA = 'BOUT',       PRES = P,  )  )

FO_ELAS1=MACRO_ELAS_MULT(            MODELE=MO,
                                   CHAM_MATER=CM,
                             CHAR_MECA_GLOBAL=BLOQU,
                            CAS_CHARGE=_F(
                                 MODE_FOURIER = 1,

                                 TYPE_MODE = 'SYME',
                                 CHAR_MECA = CH,
                                 SOUS_TITRE = 'MODE FOURIER 1 SYME')
                          )

test.assertTrue( True )

FIN()
