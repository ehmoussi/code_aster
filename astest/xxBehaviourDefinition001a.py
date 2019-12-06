# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MU       = 80000. ;
NU       = 0.3    ;
E        =  MU*2*(1.+NU)   ;

R_0__ = 66.62;
N__=    10.  ;
C__=     14363.   ;
#C__=     0.   ;
B__=     2.1 ;
D__=     494. ;
K__=    25.0   ;
Q__=     11.43 ;
H1__=    1.;

H2__=    0.;
H3__=    0.;
H4__=    0.;
H5__=    0.;
H6__=    0.;

DL__=    37.6;
DA__=    0.0 ;
RHO_0  = 0.

MATER=DEFI_MATERIAU(ELAS=_F(E=E,
                            NU=NU,),
                    MONO_VISC1=_F(N=N__,
                                  K=K__,
                                  C=C__,),
                    MONO_ISOT1=_F(R_0=R_0__,
                                  Q=Q__,
                                  B=B__,
                                  H1=H1__,
                                  H2=H2__,
                                  H3=H3__,
                                  H4=H4__,
                                  H5=H5__,
                                  H6=H6__,),

                    MONO_CINE1=_F(D=D__,),
                    );

TEST = DEFI_COMPOR(MONOCRISTAL=_F(MATER=MATER,
                                  ECOULEMENT='MONO_VISC1',
                                  ECRO_ISOT='MONO_ISOT1',
                                  ECRO_CINE='MONO_CINE1',
                                  ELAS='ELAS',
                                  FAMI_SYST_GLIS='OCTAEDRIQUE',),);

# Test trivial
test.assertTrue( True )

test.printSummary()

FIN()
