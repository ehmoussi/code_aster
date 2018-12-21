import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readAsterMeshFile("sdld109a.mail")

ACCELERO = FORMULE(NOM_PARA='INST',VALE='sin((INST)*20.*2.*3.14)')
 
L_INST=DEFI_LIST_REEL(  DEBUT=0.,
                           INTERVALLE=_F(  JUSQU_A = 0.01,  PAS = 0.001)) 

ACCE = CALC_FONC_INTERP( FONCTION=ACCELERO, LIST_PARA=L_INST,
        NOM_PARA='INST',
        NOM_RESU='ACCE',
        PROL_GAUCHE='EXCLU', PROL_DROITE='LINEAIRE',
        INTERPOL='LIN',
        TITRE=' FONCTION' )   

L_FREQ = DEFI_LIST_REEL(  DEBUT=0.1,
                           INTERVALLE=_F(  JUSQU_A = 50.,  PAS = 0.1)) 
                           

MOD_A=AFFE_MODELE(  MAILLAGE=MA,AFFE=(
                  _F(  PHENOMENE = 'MECANIQUE',  MODELISATION = 'DIS_T',
                         GROUP_MA = ('ELN1','AMN1')
                         ),)
                    )
#
CARA_A=AFFE_CARA_ELEM(  MODELE=MOD_A,
                          DISCRET=(_F(  GROUP_MA = ('ELN1',),
                                        CARA = 'M_T_D_L',  VALE = 1.),    
                                   _F(  GROUP_MA=('ELN1'),  CARA = 'K_T_D_L',
                                        VALE = (0., 0., 4000.,),  REPERE = 'GLOBAL'),
                                   _F(  GROUP_MA=('AMN1'),  CARA = 'A_T_D_L',
                                        VALE = (0., 0., 10.,),  REPERE = 'GLOBAL')     )
                         )

CON_A=AFFE_CHAR_MECA( MODELE=MOD_A,
                        DDL_IMPO=(_F( GROUP_NO = 'N01', DX = 0., DY = 0., DZ = 0.),
                                  _F( GROUP_NO = 'N02', DX = 0., DY = 0.),),
                         )
                         
RIGI_ELA=CALC_MATR_ELEM(  MODELE=MOD_A,        OPTION='RIGI_MECA',
                            CARA_ELEM=CARA_A,   CHARGE=CON_A   )

MASS_ELA=CALC_MATR_ELEM( MODELE=MOD_A,    OPTION='MASS_MECA_DIAG',
                            CARA_ELEM=CARA_A,   CHARGE=CON_A   )
                            
AMOR_ELA=CALC_MATR_ELEM( MODELE=MOD_A,    OPTION='AMOR_MECA',
                            CARA_ELEM=CARA_A,   CHARGE=CON_A   )                            

NUME_A=NUME_DDL(  MATR_RIGI=RIGI_ELA )

RIGI_A=ASSE_MATRICE(  MATR_ELEM=RIGI_ELA,   NUME_DDL=NUME_A  )
MASS_A=ASSE_MATRICE(  MATR_ELEM=MASS_ELA,   NUME_DDL=NUME_A  )
AMOR_A=ASSE_MATRICE(  MATR_ELEM=AMOR_ELA,   NUME_DDL=NUME_A  )        

TRAN_LA=DYNA_VIBRA( TYPE_CALCUL='TRAN',
                    BASE_CALCUL='PHYS',
                    MATR_MASS=MASS_A,    
                    MATR_RIGI=RIGI_A,
                    MATR_AMOR = AMOR_A,
                    INCREMENT=_F(PAS=0.001, INST_FIN=0.01),
                           )   

TAB =  CREA_TABLE(RESU =_F(RESULTAT = TRAN_LA, 
                            NOM_CHAM ='ACCE',
                            TOUT_CMP='OUI',
                            TOUT='OUI',
                            ),                  
)

tabl_spe = CALC_SPECTRE_IPM(MAILLAGE = MA,
                     AMOR_SPEC = 0.05,
                     EQUIPEMENT =(_F(NOM='NOEUD2',
                                  GROUP_NO='N02',
                                RAPPORT_MASSE_TOTALE = 0.1,
                                COEF_MASS_EQUIP = (0.5,0.25,0.25),
                                FREQ_EQUIP = (10.,30.,7.), 
                                FREQ_SUPPORT  = 10.,
                                AMOR_SUPPORT = 0.07,
                                AMOR_EQUIP = (0.05, 0.05, 0.05)
                                 ),),  
                     LIST_INST = L_INST,
                     CALCUL ='RELATIF',
                     LIST_FREQ = L_FREQ,
                     NORME = 1.,
                     RESU = (_F(TABLE = TAB,
                               ACCE_Z = ACCE,),),
)

test.assertTrue( True )

FIN()
