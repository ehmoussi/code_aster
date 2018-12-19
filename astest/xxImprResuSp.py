import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("mumps01a.mmed")

DEFI_GROUP(reuse=MA, MAILLAGE=MA, CREA_GROUP_NO=_F(TOUT_GROUP_MA='OUI'))

MO=AFFE_MODELE(MAILLAGE=MA, 
                AFFE=_F(TOUT='OUI',
                PHENOMENE='MECANIQUE',
                MODELISATION='3D'))

MAT=DEFI_MATERIAU(   ELAS=_F( E = 1.E+05,  
                              NU = 0.3, 
                              RHO=9800.)  )

CHAM_MAT=AFFE_MATERIAU( MAILLAGE=MA,  
                        AFFE=_F( TOUT = 'OUI', MATER = MAT) )
                        
CHAR=AFFE_CHAR_MECA( MODELE=MO,
       DDL_IMPO=  _F( GROUP_MA = 'BASE1',  DZ = 0., DY = 0.),)

CHARCI=AFFE_CHAR_CINE( MODELE=MO, 
                        MECA_IMPO=  _F( GROUP_NO = 'BASE1',  DX = 10.))

L1 = code_aster.TimeStepManager()
L1.setTimeList( [0., 1., 2] )
L1.build()

RESU=STAT_NON_LINE(MODELE=MO, 
                   CHAM_MATER=CHAM_MAT,
                   CONVERGENCE=_F(RESI_GLOB_MAXI=1e-6),
                   INCREMENT=_F(LIST_INST=L1),
                   EXCIT=( _F(CHARGE = CHAR),
                           _F(CHARGE = CHARCI)))

IMPR_RESU_SP(
    RESULTAT   =RESU,
    GROUP_MA   =('CUBE1',),
    RESU =(
        _F(NOM_CHAM ="SIEF_ELGA", NOM_CMP=('SIXX'),),
    ),
    UNITE =10,
)

test.assertTrue( True )

FIN()
