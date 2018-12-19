import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA_BRAS = code_aster.Mesh()
MA_BRAS.readMedFile("sdls129a.20")

MA_CENTR = code_aster.Mesh()
MA_CENTR.readMedFile("sdls129a.22")

MO_BRAS=AFFE_MODELE(MAILLAGE=MA_BRAS,
                    AFFE=_F(GROUP_MA='bras',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DKT',),);

MO_CENTR=AFFE_MODELE(MAILLAGE=MA_CENTR,
                     AFFE=_F(GROUP_MA='centre',
                             PHENOMENE='MECANIQUE',
                             MODELISATION='DKT',),);

                             
ACIER=DEFI_MATERIAU(ELAS=_F(E=2.1e11,
                            NU=0.3,
                            RHO=7800.,),);

CH_BRAS=AFFE_MATERIAU(MODELE=MO_BRAS,
                      MAILLAGE=MA_BRAS,
                      AFFE=_F(GROUP_MA='bras',
                              MATER=ACIER,),);

CH_CENTR=AFFE_MATERIAU(MODELE=MO_CENTR,
                       MAILLAGE=MA_CENTR,
                       AFFE=_F(GROUP_MA='centre',
                               MATER=ACIER,),);

CA_BRAS=AFFE_CARA_ELEM(MODELE=MO_BRAS,
                       COQUE=_F(GROUP_MA='bras',
                                EPAIS=0.005,),);

CA_CENTR=AFFE_CARA_ELEM(MODELE=MO_CENTR,
                        COQUE=_F(GROUP_MA='centre',
                                 EPAIS=0.005,),);

CL_BRAS=AFFE_CHAR_MECA(MODELE=MO_BRAS,
                       DDL_IMPO=(_F(GROUP_NO=('intf',),
                                    DX=0.,
                                    DY=0.,
                                    DZ=0.,
                                    DRX=0.,
                                    DRY=0.,
                                    DRZ=0.,
                                   ),
                                 _F(GROUP_NO=('CL',),
                                    DX=0.,
                                    DY=0.,
                                    DZ=0.,
                                    DRX=0.,
                                    DRY=0.,
                                    DRZ=0.,),  
                                   ),);

CL_CENTR=AFFE_CHAR_MECA(MODELE=MO_CENTR,
                        DDL_IMPO=_F(GROUP_NO=('intf_px','intf_py','intf_my',),
                                    DX=0.,
                                    DY=0.,
                                    DZ=0.,
                                    DRX=0.,
                                    DRY=0.,
                                    DRZ=0.,
                                    ),);

BRAS=CREA_ELEM_SSD(MODELE=MO_BRAS,
                   CHAM_MATER=CH_BRAS,
                   CARA_ELEM=CA_BRAS,
                   NUME_DDL=CO('NU_BRAS'),
                   CHARGE=CL_BRAS,
                   INTERFACE=_F(NOM='INT_BR',
                                TYPE='CRAIGB',
                                GROUP_NO='intf',),
                   CALC_FREQ=_F(NMAX_FREQ=10,
                                  APPROCHE='REEL',
                                  STOP_ERREUR='OUI',
                                  OPTION='PLUS_PETITE',),             
                   BASE_MODALE=_F(TYPE='CLASSIQUE',),
                   );

CENTRE=CREA_ELEM_SSD(MODELE=MO_CENTR,
                     CHAM_MATER=CH_CENTR,
                     CARA_ELEM=CA_CENTR,
                     NUME_DDL=CO('NU_CENTR'),
                     CHARGE=CL_CENTR,
                     INTERFACE=(_F(NOM='INT_PX',
                                   TYPE='CRAIGB',
                                   GROUP_NO='intf_px',),
                                _F(NOM='INT_PY',
                                   TYPE='CRAIGB',
                                   GROUP_NO='intf_py',),
                                _F(NOM='INT_MY',
                                   TYPE='CRAIGB',
                                   GROUP_NO='intf_my',),),
                     CALC_FREQ=_F(NMAX_FREQ=12,
                                  APPROCHE='REEL',
                                  STOP_ERREUR='OUI',
                                  OPTION='PLUS_PETITE',),
                     BASE_MODALE=_F(TYPE='CLASSIQUE',),
                     );

ASSE_ELEM_SSD(RESU_ASSE_SSD=_F(MODELE=CO('MODGEN'),
                               NUME_DDL_GENE=CO('NUMGEN'),
                               RIGI_GENE=CO('KGEN'),
                               MASS_GENE=CO('MGEN'),),
              SOUS_STRUC=(_F(NOM='CENTRE',
                             MACR_ELEM_DYNA=CENTRE,
                             ANGL_NAUT=(0.,0.,0.,),
                             TRANS=(0.,0.,0.,),),
                          _F(NOM='BR_PX',
                             MACR_ELEM_DYNA=BRAS,
                             ANGL_NAUT=(0.,0.,90.,),
                             TRANS=(0.,0.,0.,),),
                          _F(NOM='BR_PY',
                             MACR_ELEM_DYNA=BRAS,
                             ANGL_NAUT=(120.,0.,90.,),
                             TRANS=(0.,0.,0.,),),
                          _F(NOM='BR_MY',
                             MACR_ELEM_DYNA=BRAS,
                             ANGL_NAUT=(-120.,0.,90.,),
                             TRANS=(0.,0.,0.,),),),
              LIAISON=(_F(SOUS_STRUC_1='CENTRE',
                          INTERFACE_1='INT_PY',
                          SOUS_STRUC_2='BR_PY',
                          INTERFACE_2='INT_BR',
                          ),
                       _F(SOUS_STRUC_1='CENTRE',
                          INTERFACE_1='INT_PX',
                          SOUS_STRUC_2='BR_PX',
                          INTERFACE_2='INT_BR',
                          ),
                       _F(SOUS_STRUC_1='CENTRE',
                          INTERFACE_1='INT_MY',
                          SOUS_STRUC_2='BR_MY',
                          INTERFACE_2='INT_BR',
                          ),),
             METHODE='CLASSIQUE',
             STOCKAGE='PLEIN',
             VERIF=_F(STOP_ERREUR='NON',
                       PRECISION=1e-3,
                       CRITERE='ABSOLU',),
                       );

test.assertTrue( True )

FIN()
