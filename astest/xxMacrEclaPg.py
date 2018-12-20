import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readAsterMeshFile("sslv131a.mail")

DEFI_GROUP( reuse=MA,   MAILLAGE=MA,
            CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'))


MATISTR=DEFI_MATERIAU(
           ELAS_ISTR=_F(  E_L = 11000.,   E_N = 8000.,
                          NU_LN = 0.15,   NU_LT = 0.18,
                           G_LN = 7000.) )

CHMATIST=AFFE_MATERIAU(  MAILLAGE=MA,
           AFFE=_F(  TOUT = 'OUI',   MATER = MATISTR) )

MOD3D=AFFE_MODELE(  MAILLAGE=MA,
           AFFE=_F( MAILLE = 'TET1', MODELISATION = '3D',
           PHENOMENE = 'MECANIQUE'))

CAREL3D=AFFE_CARA_ELEM(MODELE=MOD3D,
                       MASSIF=_F(  GROUP_MA = 'TOUT',
                                   ANGL_REP = (30.,20.,10.,)))

CHAR3D=AFFE_CHAR_MECA(  MODELE=MOD3D,DDL_IMPO=(
              _F( NOEUD = 'A',   DX = 0.,       DY = 0.,     DZ = 0.),
              _F( NOEUD = 'B',   DX = 9.,       DY = 14.,    DZ = 18.),
              _F( NOEUD = 'C',   DX = 13.,      DY = 21.,    DZ = 26.),
              _F( NOEUD = 'D',   DX = 5.,      DY = 8.,    DZ = 11.)))

LISTE = code_aster.TimeStepManager()
LISTE.setTimeList( [n*0.2 for n in range(6)] )
LISTE.build()


FONC=DEFI_FONCTION(NOM_PARA='INST',VALE=(0.,0.,1.,1.),);

MEST1=STAT_NON_LINE(MODELE=MOD3D,
                    CHAM_MATER=CHMATIST,
                    CARA_ELEM=CAREL3D,
                    EXCIT=_F( CHARGE = CHAR3D,FONC_MULT=FONC),
                    NEWTON=_F(PREDICTION='TANGENTE'),
                    COMPORTEMENT=_F(RELATION='ELAS'),
                    INCREMENT=_F(LIST_INST=LISTE),);

MACR_ECLA_PG( RESULTAT = CO('MEST_PG'),
              MAILLAGE = CO('MA2'),
              RESU_INIT = MEST1,
              MODELE_INIT = MOD3D,
              NOM_CHAM = 'SIEF_ELGA',
             )

test.assertTrue( True )

FIN()
