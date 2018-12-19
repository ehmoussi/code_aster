import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz213a.mmed")

model = AFFE_MODELE(MAILLAGE=MA, AFFE=_F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION='D_PLAN'));

mat = DEFI_MATERIAU(ELAS=_F(E  = 1.,  NU = 0.,),);
chmat = AFFE_MATERIAU(MAILLAGE=MA, AFFE=_F(TOUT  = 'OUI', MATER = mat),);

ch0=AFFE_CHAR_MECA(MODELE=model, DDL_IMPO= _F(GROUP_MA='AB',DX=0.,DY=1.), );
chcine=AFFE_CHAR_CINE(MODELE=model,  MECA_IMPO=(_F(GROUP_MA='CD',DY=2.), ));

rigiel = CALC_MATR_ELEM(MODELE= model, CHAM_MATER= chmat, OPTION= 'RIGI_MECA', CHARGE=ch0)

nu11    = NUME_DDL(MATR_RIGI = rigiel);
vcine11 = CALC_CHAR_CINE(NUME_DDL=nu11, CHAR_CINE=chcine)

test.assertTrue( True )

FIN()
