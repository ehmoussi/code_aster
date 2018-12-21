import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readGmshFile("ssnp139a.msh")

MA  =  DEFI_GROUP(
    reuse  = MA,
    MAILLAGE = MA,
    CREA_GROUP_MA = (
     _F(NOM = 'DCB_G',  GROUP_MA = 'GM981'),
     _F(NOM = 'DCB_D',  GROUP_MA = 'GM982'),
     _F(NOM = 'DCB_JH', GROUP_MA = 'GM983'),
     _F(NOM = 'DCB_JB', GROUP_MA = 'GM984'),
     _F(NOM = 'DCB_HG', GROUP_MA = 'GM985'),
     _F(NOM = 'DCB_HD', GROUP_MA = 'GM986'),
     _F(NOM = 'DCB_BG', GROUP_MA = 'GM987'),
     _F(NOM = 'DCB1'  ,  GROUP_MA = 'GM988'),
     _F(NOM = 'DCB2'  ,  GROUP_MA = 'GM989'),
     _F(NOM = 'DCBJ'  ,  GROUP_MA = 'GM990'),
   ),

    CREA_GROUP_NO = (
     _F(NOM = 'DCB_G',  GROUP_MA = 'GM981'),
     _F(NOM = 'NO_7',   GROUP_MA = 'GM954'),
  )
)

MA=MODI_MAILLAGE(reuse =MA,
                 MAILLAGE=MA,
                 ORIE_FISSURE=_F(GROUP_MA='DCBJ'),
                 )

MO=AFFE_MODELE(

                MAILLAGE=MA,
                AFFE= (
                _F(
                        GROUP_MA = ('DCB1','DCB2','DCB_G',  'DCBJ'),
                        PHENOMENE = 'MECANIQUE',
                        MODELISATION = 'D_PLAN'
                     ),
                 ))

MATE=DEFI_MATERIAU(
     ELAS=_F(
             E =  200000.0,
             NU = 0.3,
             ALPHA = 1.e-4),
        MOHR_COULOMB  =_F(
                PHI    = 33.,
                ANGDIL   = 27.,
                COHESION = 200000.0,),
             )


CM=AFFE_MATERIAU(
               MAILLAGE=MA,
               AFFE=_F(
                       GROUP_MA = ('DCB1','DCB2','DCBJ'),
                       MATER = MATE),
              )

SYMETRIE = AFFE_CHAR_MECA(
  MODELE = MO,
  FACE_IMPO = ( _F(GROUP_MA='DCB_JB',DY = 0))
 )

TRACTION = AFFE_CHAR_MECA(
 MODELE = MO,
  DDL_IMPO = (_F(GROUP_NO = 'NO_7'   ,DX = 0)),
  FACE_IMPO= (_F(GROUP_MA = 'DCB_G'  ,DY = 1 ),
            ))

L_INST=DEFI_LIST_REEL(DEBUT   = 0.0,
     INTERVALLE=(
      _F( JUSQU_A = 1.0  ,   NOMBRE = 2 ),

      ))

INS_ARCH=DEFI_LIST_REEL(DEBUT   = 0.0,
     INTERVALLE=(
      _F( JUSQU_A = 1.0  ,   NOMBRE = 2),

      ))

FCT_E = DEFI_FONCTION(
  NOM_PARA = 'INST',
  VALE     = (-1,0 ,  0,0,   1.0 , 1.1 ),

                )
DEFLIST =DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST = L_INST ),
                        ECHEC=_F(
                  ACTION       = 'DECOUPE',
                  SUBD_METHODE = 'MANUEL',
                  SUBD_PAS  = 5,
                  SUBD_PAS_MINI = 1.E-10,
                  SUBD_NIVEAU=10,
                                 ))

U_ELAS=STAT_NON_LINE( INFO=1,
  MODELE     = MO,
  CHAM_MATER = CM,
  EXCIT      = (
                 _F(CHARGE = SYMETRIE),
                 _F(CHARGE = TRACTION,FONC_MULT = FCT_E),
               ),
  COMPORTEMENT=_F(RELATION='MOHR_COULOMB',),
  INCREMENT  = _F(LIST_INST = DEFLIST,
                  INST_FIN = 1.0,
                  ),
  NEWTON     = _F(MATRICE    = 'TANGENTE'  , REAC_ITER=1),
  CONVERGENCE = _F(
                   RESI_GLOB_RELA = 1.E-6,
                   ITER_GLOB_MAXI = 8,
                  ),
  ARCHIVAGE = _F(LIST_INST     = INS_ARCH),
  SOLVEUR=_F(METHODE='MUMPS',MATR_DISTRIBUEE='OUI'),

  )

U_ELAS = CALC_CHAMP(reuse = U_ELAS,
               RESULTAT = U_ELAS,
               FORCE='FORC_NODA',
               TOUT = 'OUI',
               )


L_CZM_E = POST_CZM_FISS(RESULTAT = U_ELAS,
                      OPTION='LONGUEUR',
                      GROUP_MA='DCBJ',
                      POINT_ORIG = (0.0 , -0.0433379036959),
                      VECT_TANG  = (99.9154700538, 0.0288675134595))

test.assertTrue( True )

FIN()
