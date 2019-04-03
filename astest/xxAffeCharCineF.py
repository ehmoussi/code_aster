import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("tpla01a.mmed")

MOTH=AFFE_MODELE(  MAILLAGE=MA,
                      AFFE=_F( TOUT = 'OUI', MODELISATION = 'AXIS',
                                      PHENOMENE = 'THERMIQUE'))


C20=DEFI_FONCTION(NOM_PARA='INST', VALE=(-10.,20., 1000.,20.,))

C100=DEFI_CONSTANTE(VALE=100.)

CHT3=AFFE_CHAR_CINE_F(  MODELE=MOTH,THER_IMPO=(
          _F( GROUP_NO = 'GRNM15', TEMP = C100)))

print(CHT3)

test.assertTrue( True )

FIN()
