
import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

MESH = code_aster.Mesh()
MESH.readMedFile("xxEvolutiveLoad001a.med")

MODEL=AFFE_MODELE(MAILLAGE=MESH, AFFE=_F(TOUT='OUI', PHENOMENE='THERMIQUE', MODELISATION='AXIS') )

TEMP_EX1 = CREA_CHAMP(TYPE_CHAM = 'CART_TEMP_R',
                     OPERATION = 'AFFE',
                     MODELE    = MODEL,
                     AFFE      = (_F(GROUP_MA='AB',
                                     NOM_CMP=('TEMP',),
                                     VALE=(0.,),
                                    ),),
                     )

TEMP_EX2 = CREA_CHAMP(TYPE_CHAM = 'CART_TEMP_R',
                     OPERATION = 'AFFE',
                     MODELE    = MODEL,
                     AFFE      = (_F(GROUP_MA='AB',
                                     NOM_CMP=('TEMP',),
                                     VALE=(50.,),
                                    ),),
                     )

TEMP_EX3 = CREA_CHAMP(TYPE_CHAM = 'CART_TEMP_R',
                      OPERATION = 'AFFE',
                      MODELE    = MODEL,
                      AFFE      = (_F(GROUP_MA='AB',
                                      NOM_CMP=('TEMP',),
                                      VALE=(50.,),
                                    ),),
                     )

EVOL_RE = CREA_RESU(OPERATION='AFFE',
                    TYPE_RESU='EVOL_CHAR',
                    NOM_CHAM='T_EXT',
                    AFFE=(_F( CHAM_GD=TEMP_EX1, INST=0., PRECISION=0.0, CRITERE='RELATIF'),
                          _F( CHAM_GD=TEMP_EX2, INST=0.5, PRECISION=0.0, CRITERE='RELATIF'),
                          _F( CHAM_GD=TEMP_EX3, INST=1.0, PRECISION=0.0, CRITERE='RELATIF'),
                          ),
                    )

TEMP_EX4 = CREA_CHAMP(TYPE_CHAM = 'NOEU_TEMP_R',
                     OPERATION = 'AFFE',
                     MODELE    = MODEL,
                     AFFE      = (_F(GROUP_MA='AB',
                                     NOM_CMP=('TEMP',),
                                     VALE=(50.,),
                                    ),),
                     )

EVOL_RE = CREA_RESU(OPERATION='AFFE',
                    TYPE_RESU='EVOL_THER',
                    NOM_CHAM='TEMP',
                    AFFE=(_F( CHAM_GD=TEMP_EX4, INST=0., PRECISION=0.0, CRITERE='RELATIF'),
                          ),
                    )

# Test trivial
test.assertTrue( True )
