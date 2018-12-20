import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("ssnv164a.mmed")

MA=DEFI_GROUP(reuse =MA,
              MAILLAGE=MA,
              CREA_GROUP_NO=_F(GROUP_MA=('CAB5',
                                          'CAB1',
                                          'CAB4',
                                          'CAB3',
                                          'CAB2',
                                          'PP',
                                          'SU3',
                                          ),),);

MO=AFFE_MODELE(MAILLAGE=MA,
               AFFE=(_F(GROUP_MA='VOLTOT',
                        PHENOMENE='MECANIQUE',
                        MODELISATION='3D',),
                     _F(GROUP_MA=('CAB1',
                                   'CAB2',
                                   'CAB3',
                                   'CAB4',
                                   'CAB5',),
                        PHENOMENE='MECANIQUE',
                        MODELISATION='BARRE',),),);

CE=AFFE_CARA_ELEM(MODELE=MO,
                  BARRE=_F(GROUP_MA=('CAB5',
                                      'CAB4',
                                      'CAB3',
                                      'CAB2',
                                      'CAB1',),
                           SECTION='CERCLE',
                           CARA='R',
                           VALE=2.8209E-2,),);

MBETON=DEFI_MATERIAU(ELAS=_F(E=4.E10,
                             NU=0.2,
                             RHO=2500.,),
                     BPEL_BETON=_F(),);

MCABLE=DEFI_MATERIAU(ELAS=_F(E=1.93E11,
                             NU=0.3,
                             RHO=7850.,),
                     BPEL_ACIER=_F(F_PRG=1.94E11,
                                   FROT_COURB=0.0,
                                   FROT_LINE=1.5E-3,),);

CMAT=AFFE_MATERIAU(MAILLAGE=MA,
                   AFFE=(_F(GROUP_MA='VOLTOT',
                            MATER=MBETON,),
                         _F(GROUP_MA=('CAB1',
                                       'CAB2',
                                       'CAB3',
                                       'CAB4',
                                       'CAB5',
                                       ),
                            MATER=MCABLE,),),);

CLIM=AFFE_CHAR_MECA(MODELE=MO,
                    PESANTEUR=_F(GRAVITE=9.81,
                                 DIRECTION=(0.,0.,-1.,),),
                    DDL_IMPO=(_F(GROUP_NO='PX',
                                 DY=0.,),
                              _F(GROUP_NO='PY',
                                 DX=0.,),
                              _F(GROUP_NO='PP',
                                 DX=0.,
                                 DY=0.,),
                              _F(GROUP_NO='SU3',
                                 DZ=0.,),),);

CAB_BP=DEFI_CABLE_BP(MODELE=MO,
                      CHAM_MATER=CMAT,
                      CARA_ELEM=CE,
                      GROUP_MA_BETON='VOLTOT',
                      DEFI_CABLE=(_F(GROUP_MA='CAB1',
                                     GROUP_NO_ANCRAGE= ('PC1D','PC1F'),),
                                  _F(GROUP_MA='CAB2',
                                     GROUP_NO_ANCRAGE=('PC2D','PC2F'),),
                                  _F(GROUP_MA='CAB3',
                                     GROUP_NO_ANCRAGE=('PC3D','PC3F'),),
                                  _F(GROUP_MA='CAB4',
                                     GROUP_NO_ANCRAGE=('PC4D','PC4F'),),
                                  _F(GROUP_MA='CAB5',
                                     GROUP_NO_ANCRAGE=('PC5D','PC5F'),),),
                      TYPE_ANCRAGE=('ACTIF','PASSIF',),
                      TENSION_INIT=3.75E6,
                      RECUL_ANCRAGE=0.001,);




CMCAB=AFFE_CHAR_MECA(MODELE=MO,
                      RELA_CINE_BP=_F(CABLE_BP=CAB_BP,
                                      SIGM_BPEL='NON',
                                      RELA_CINE='OUI',),);


LIST=DEFI_LIST_REEL(VALE=(0.,600.,),
                    INFO=1,);

RES0=CALC_PRECONT (MODELE=MO,
                   CHAM_MATER=CMAT,
                   CARA_ELEM=CE,
                   CABLE_BP=CAB_BP,
                   EXCIT=(_F(CHARGE=CLIM,),),
                   COMPORTEMENT=(_F(RELATION='ELAS',
                                 GROUP_MA='VOLTOT',),
                              _F(RELATION='ELAS',
                                 GROUP_MA='CABLE',),),
                   INCREMENT=_F(LIST_INST=LIST,),
                   NEWTON=_F(),);

test.assertTrue( True )

FIN()
