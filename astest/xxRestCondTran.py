import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAYA = code_aster.Mesh()
MAYA.readAsterMeshFile("sdll113c.mail")

MATERIO=DEFI_MATERIAU(  ELAS=_F( RHO = 1.E04,  NU = 0.3,  E = 1.E10,
                                 AMOR_ALPHA = 6.5E-6,  AMOR_BETA = 16.));

MAYA=DEFI_GROUP( reuse=MAYA,   MAILLAGE=MAYA,
  CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'));

MAYA=DEFI_GROUP(reuse=MAYA, MAILLAGE=MAYA, CREA_GROUP_NO=_F(NOM='GN004', NOEUD='N4'))

CHMAT=AFFE_MATERIAU(  MAILLAGE=MAYA,
                              AFFE=_F( TOUT = 'OUI',
                                    MATER = MATERIO));
                                    

MODELE1=AFFE_MODELE(MAILLAGE=MAYA,
                   AFFE=(_F(GROUP_MA=('ELEM1',),
                            PHENOMENE='MECANIQUE',
                            MODELISATION='POU_D_T',),
                         ),
                   );
ELEM1=AFFE_CARA_ELEM(MODELE=MODELE1,
                           POUTRE=_F(
                                   GROUP_MA = 'ELEM1',
                                   SECTION = 'CERCLE',
                                   CARA = ('R', 'EP',),
                                   VALE = (0.1, 0.01,),
                                   ),
                        );                   
COND_LI1=AFFE_CHAR_MECA(    MODELE=MODELE1,
                     DDL_IMPO=(
                           _F( TOUT = 'OUI',
                                DY = 0., DZ = 0., 
                                DRX = 0., DRY = 0., DRZ = 0.),
                           _F( NOEUD = 'N4',    DX = 0.),
                               ),
                        ); 
                        
ASSEMBLAGE(MODELE=MODELE1,
                CHAM_MATER=CHMAT,
                CARA_ELEM=ELEM1,
                CHARGE=(COND_LI1),
                NUME_DDL=CO('NUME1'),
                MATR_ASSE=(_F(MATRICE=CO('MATR1'),
                              OPTION='RIGI_MECA',),
                           _F(MATRICE=CO('MATM1'),
                              OPTION='MASS_MECA',),
                           _F(MATRICE=CO('MATA1'),
                              OPTION='AMOR_MECA',),
                           ),
                );
                
MODE1=CALC_MODES(MATR_RIGI=MATR1,
                 VERI_MODE=_F(STOP_ERREUR='NON',
                              ),
                 CALC_FREQ=_F(NMAX_FREQ=6,
                              ),
                 MATR_MASS=MATM1,
                 )

                                                 
                         
MODSTA1=MODE_STATIQUE(MATR_RIGI=MATR1,
                      MATR_MASS=MATM1,
                      MODE_STAT=_F(GROUP_NO='GN004',
                                   TOUT_CMP='OUI',
                                   ),
                                  );
                                   
INTERDY1=DEFI_INTERF_DYNA(  NUME_DDL=NUME1,
            INTERFACE=_F( NOM = 'DROITE',
                       TYPE = 'CRAIGB',
                       NOEUD='N4',)
           );                        

BAMO1=DEFI_BASE_MODALE(RITZ=(_F(MODE_MECA=MODE1,
                                NMAX_MODE=6,),
                             _F(MODE_INTF=MODSTA1,
                                NMAX_MODE=1999,),
                             ),
                       INTERF_DYNA=INTERDY1,
                       NUME_REF=NUME1,);
                       
CHPE11=AFFE_CHAR_MECA(MODELE=MODELE1,
                        FORCE_NODALE=_F( NOEUD = 'N10',  FX = -100.));

                     
VEC1_ELE=CALC_VECT_ELEM(  OPTION='CHAR_MECA',
                          CHAM_MATER=CHMAT,
                          CARA_ELEM=ELEM1,
                          CHARGE=CHPE11,
                        );
                        
VECAS1=ASSE_VECTEUR(  VECT_ELEM=VEC1_ELE,  NUME_DDL=NUME1 ); 
                       
NDDLGE1 = NUME_DDL_GENE( BASE= BAMO1, STOCKAGE= 'PLEIN',);

VECGE1=PROJ_VECT_BASE(  BASE=BAMO1,  NUME_DDL_GENE=NDDLGE1,
                            VECT_ASSE=VECAS1 );
                       
MAEL1=MACR_ELEM_DYNA(  BASE_MODALE=BAMO1,
                       MATR_RIGI=MATR1,
                       MATR_MASS=MATM1,
                       MATR_AMOR=MATA1,
                       CAS_CHARGE=(
                                 _F(NOM_CAS='CHP1',
                                    VECT_ASSE_GENE=VECGE1,),
                                   ),
                     );
                     
MAYADYN=DEFI_MAILLAGE(DEFI_SUPER_MAILLE=(
                          _F(MACR_ELEM=MAEL1,
                             SUPER_MAILLE='STAT1',),
                                         ),
                      RECO_GLOBAL=_F(TOUT='OUI',),
                      DEFI_NOEUD=_F(TOUT='OUI',
                                     INDEX=(1,0,1,8,),),);
                                     
MAILB=ASSE_MAILLAGE(MAILLAGE_1=MAYA,
                    MAILLAGE_2=MAYADYN,
                    OPERATION='SOUS_STR',);
                    
                    
CHMATB=AFFE_MATERIAU(MAILLAGE=MAILB,
                     AFFE=(                            
                            _F(GROUP_MA='ELEM0',
                               MATER=MATERIO,),
                           ),
                     );                    
                     
MODELB=AFFE_MODELE(MAILLAGE=MAILB,
                   AFFE_SOUS_STRUC=_F(SUPER_MAILLE=('STAT1',),
                                      PHENOMENE='MECANIQUE',),
                   AFFE=(
                         _F(GROUP_MA='ELEM0',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='POU_D_T',),
                        ),
                  );
                  
ELEMB=AFFE_CARA_ELEM(MODELE=MODELB,
                           POUTRE=_F(
                                   GROUP_MA = 'ELEM0',
                                   SECTION = 'CERCLE',
                                   CARA = ('R', 'EP',),
                                   VALE = (0.1, 0.01,),
                                   ),
                        );
                                           
COND_LIB=AFFE_CHAR_MECA(    MODELE=MODELB,
                     DDL_IMPO=(
                           _F( NOEUD = 'A',
                                DX = 0., DY = 0., DZ = 0., 
                                DRX = 0., DRY = 0., DRZ = 0.),
                           _F( NOEUD = ('N1','N2','N3','N4',),
                                DY = 0., DZ = 0., 
                                DRX = 0., DRY = 0., DRZ = 0.),
                               ),
                        );
                        
                        
ASSEMBLAGE(MODELE=MODELB,
                CHAM_MATER=CHMATB,
                CARA_ELEM=ELEMB,
                CHARGE=COND_LIB,
                NUME_DDL=CO('NUMEROTB'),
                MATR_ASSE=(_F(MATRICE=CO('MATRRIGB'),
                              OPTION='RIGI_MECA',),
                           _F(MATRICE=CO('MATRMASB'),
                              OPTION='MASS_MECA',),
                           _F(MATRICE=CO('MATRAMOB'),
                              OPTION='AMOR_MECA',),
                           ),
               );
               
MODEB=CALC_MODES(MATR_RIGI=MATRRIGB,
                 VERI_MODE=_F(STOP_ERREUR='NON',
                              ),
                 CALC_FREQ=_F(NMAX_FREQ=20,
                              ),
                 MATR_MASS=MATRMASB,
                 )

                         
CHFONO=AFFE_CHAR_MECA(MODELE=MODELB,
                        FORCE_NODALE=_F( NOEUD = 'N4',  FX = 0.));                         
                         
                         
VELFO=CALC_VECT_ELEM(    OPTION='CHAR_MECA',
           CHARGE=CHFONO, 
           CHAM_MATER=CHMATB, CARA_ELEM=ELEMB,
           MODELE=MODELB, 
           SOUS_STRUC=_F( CAS_CHARGE = 'CHP1', SUPER_MAILLE = 'STAT1',)
               );
               
VECASFO=ASSE_VECTEUR(   NUME_DDL=NUMEROTB,  VECT_ELEM=VELFO);                                        
                         
EVOLB=DYNA_VIBRA(TYPE_CALCUL='TRAN',BASE_CALCUL='PHYS',
                      MATR_MASS=MATRMASB, MATR_RIGI=MATRRIGB,
                      MATR_AMOR=MATRAMOB,
                      SCHEMA_TEMPS=_F(SCHEMA='NEWMARK',), 
                      INCREMENT=_F( PAS=1.e-6, INST_INIT=0., INST_FIN=1.e-3),
                      ARCHIVAGE=_F( PAS_ARCH=100),
                      SOLVEUR=_F(RESI_RELA=-1.0),
                     EXCIT=(
                            _F( VECT_ASSE=VECASFO, COEF_MULT = 1.0,),
                            ),                            
                    );
                    
TEMPL2B=DEFI_LIST_REEL(       DEBUT=5.E-4,
                           INTERVALLE=_F( JUSQU_A = 1E-3,
                                       NOMBRE = 5));  
                    
RESUGLOB=REST_COND_TRAN( RESULTAT=EVOLB,
                         MACR_ELEM_DYNA=MAEL1,
                         LIST_INST=TEMPL2B,
                         PRECISION=1.E-4,
                         NOM_CHAM=('DEPL','VITE','ACCE'),
                       );
                  
test.assertTrue( True )

FIN()
