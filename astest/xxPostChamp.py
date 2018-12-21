import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ssls502a.mmed")

MO=AFFE_MODELE(MAILLAGE=MA,
               AFFE=_F(TOUT='OUI',
                       PHENOMENE='MECANIQUE',
                       MODELISATION='DKT',),);

MA=DEFI_GROUP(reuse =MA,
                MAILLAGE=MA,
                CREA_GROUP_NO=_F(OPTION='NOEUD_ORDO',
                                 NOM='CD',
                                 GROUP_MA='CD',
                                 GROUP_NO_ORIG='C',
                                 GROUP_NO_EXTR='D',),);

CAR_ELE=AFFE_CARA_ELEM(MODELE=MO,
                       COQUE=_F(GROUP_MA='TOUT_ELT',
                                EPAIS=0.0061,
                                ANGL_REP=(0.0,0.0,),),);

MAT=DEFI_MATERIAU(ELAS=_F(E=210*1e9, NU=0.3))

CHAM_MAT=AFFE_MATERIAU(MAILLAGE=MA,
                       AFFE=_F(TOUT='OUI',
                               MATER=MAT,),);

CHA=AFFE_CHAR_MECA(MODELE=MO,
                   DDL_IMPO=(_F(GROUP_MA='BA',
                                DX=0.0,
                                DZ=0.0,
                                DRY=0.0,),
                             _F(GROUP_MA=('AD','BC',),
                                DX=0.0,
                                DRY=0.0,
                                DRZ=0.0,),
                             _F(GROUP_MA='CD',
                                DY=0.0,
                                DRX=0.0,
                                DRZ=0.0,),),
                   FORCE_ARETE=_F(GROUP_MA='BC',
                                  FZ=-1178.5715,),);

L_INST = code_aster.TimeStepManager()
L_INST.setTimeList( [0., 1.] )
L_INST.build()

RESU=STAT_NON_LINE(MODELE=MO,
                   CHAM_MATER=CHAM_MAT,
                   CARA_ELEM=CAR_ELE,
                   EXCIT=_F(CHARGE=CHA,),
                   INCREMENT=_F(LIST_INST = L_INST),
                   CONVERGENCE=_F(RESI_GLOB_RELA = 1.0E-04,
                                   ITER_GLOB_MAXI = 25)
                 )

RESU=CALC_CHAMP(reuse=RESU,RESULTAT=RESU,CONTRAINTE=('SIGM_ELNO'))

RESU2=POST_CHAMP(RESULTAT=RESU,
                 EXTR_COQUE=_F(NOM_CHAM='SIGM_ELNO',
                               NUME_COUCHE=1,
                               NIVE_COUCHE='SUP',),);

test.assertTrue( True )

FIN()
