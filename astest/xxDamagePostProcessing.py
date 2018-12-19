#!/usr/bin/python
# coding: utf-8

import code_aster
import numpy as NP
import copy

from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

# --PARAMETRES DE LA POST_ENDO_FISS
#
Delta = 1.85
lort  = 15*Delta
lreg  = Delta*0.5
pas   = Delta
seuil = 10.**(-3)


# --LECTURE MAILLAGE--
#
MAIL = LIRE_MAILLAGE(FORMAT='MED')


# --LECTURE DU CHAMP A POST-TRAITER--
#   On ne lit que la premiere variable interne DX
#
U1 = LIRE_RESU( TYPE_RESU  = 'EVOL_NOLI',
                FORMAT     = 'MED',
                MAILLAGE   = MAIL,
                FORMAT_MED = (_F( NOM_CHAM_MED= 'U1______DEPL____________________',
                                  NOM_CHAM    = 'DEPL',
                                  NOM_CMP     = ('DX',),
                                  NOM_CMP_MED = ('DX',),),),
                UNITE      = 80,
                INST       = 1.,)


# --RECHERCHE DU TRAJET DE FISSURATION--
# On donne en entree un modele, parce que le resultat
#  ne contient que le maillage
MAFI = POST_ENDO_FISS( TABLE      = CO('TAB_FISS'),
                       RESULTAT   = U1,
                       INST       = 1.,
                       NOM_CHAM   = 'DEPL',
                       NOM_CMP    = 'DX',
                       RECHERCHE  = _F( LONG_ORTH = lort,
                                        PAS       = pas,
                                        LONG_REG  = lreg,
                                        BORNE_MIN = seuil,
                                     ),)


# --CALCUL DU TRAJET DE FISSURATION ANALYTIQUE--
#
Coeff = (NP.array([[-1.70666667e-05,
                     4.09600000e-03,
                    -3.25973333e-01,
                     9.62560000e+00,
                    -6.75840000e+01,
                    ]])).T

Exp = NP.array([4, 3, 2, 1, 0])

def crack_point(X) :
    if type(X)==float :
        X = NP.array([X])
    X = (NP.repeat([X],len(Exp),axis=0)).T
    Y = NP.dot((X**Exp),Coeff)
    if NP.shape(Y)[1]* NP.shape(Y)[0] == 1 :
        Y=float(Y)
    return Y

Xcourbe = NP.arange(9.,111.,0.01)
Ycourbe = crack_point(Xcourbe)

def dist_crack_path(x1,y1) :
    Dist2  = (Xcourbe-x1)**2 + (Ycourbe-y1)**2
    dist   = (NP.min(Dist2))**0.5
    return dist


CRACKPNT = FORMULE(VALE     = 'crack_point(COORX)',
                   NOM_PARA = ('COORX',),)

DIST = FORMULE(VALE     = 'dist_crack_path(COORX, COORY)',
               NOM_PARA = ('COORX','COORY'),)

TAB_FISS = CALC_TABLE(reuse  = TAB_FISS,
                      TABLE  = TAB_FISS,
                      ACTION = (_F(OPERATION = 'OPER',
                                   FORMULE   = CRACKPNT,
                                   NOM_PARA  = 'REFERENCE',),
                                _F(OPERATION = 'OPER',
                                   FORMULE   = DIST,
                                   NOM_PARA  = 'DIST',),
                            ), )


# --TEST RESULTATS--
#
TEST_TABLE(CRITERE='ABSOLU',
           REFERENCE='ANALYTIQUE',
           PRECISION=0.050000000000000003,
           VALE_CALC=0.020829706,
           VALE_REFE=0.0,
           NOM_PARA='DIST',
           TYPE_TEST='MAX',
           TABLE=TAB_FISS,)

test.printSummary()

FIN()
