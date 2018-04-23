# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

from code_aster.Cata.Syntax import _F
from code_aster.Cata.Commands import CALC_TABLE, DETRUIRE


def relative_error(X, Xref, coef=1., prec_zero=0.):
    """calcul erreur relative entre deux nombres"""
    if Xref < prec_zero:
        err = 0.
    else:
        err = abs((X * coef - Xref) / Xref)
    return err

def vect_prod_rot(X1, X2):
    """calcul Produit de 2 vecteurs pour les coef de rotations
    dimension de X1 et X2 liste de 3 scalaire resultat liste de 6 scalaire"""
    if not (len(X1) == len(X2) == 3):
        raise ValueError("CALCUL vect_prod_rot IMPOSSIBLE, "
                         "dimensions inattendues")
    Y = [None] * 6
    V_ind = [[0, 0, 0.5], [1, 1, 0.5], [2, 2, 0.5],
                [0, 1, 1.0], [0, 2, 1.0], [1, 2, 1.0]]
    for ind in V_ind:
        i = V_ind.index(ind)
        ind1, ind2, coef = ind[0], ind[1], ind[2]
        Y[i] = coef * (X1[ind1] * X2[ind2] + X1[ind2] * X2[ind1])
    return Y

def rename_components(i, N_pas, label_cal, ch_param, RESU, R_SI):
    """On renomme les composantes en fonction de  l'ordre de discrétisation"""
    N = N_pas[i]
    chN = label_cal[i] + str(N)
    for ch in ch_param:
        j = ch_param.index(ch)
        chnew = ch + chN
        # Extraction par type de variable
        if R_SI[j] == None:
            R_SI[j] = CALC_TABLE(TABLE=RESU[i],
                                 TITRE=' ',
                                 ACTION=(_F(OPERATION='EXTR',
                                            NOM_PARA=('INST', ch,),),
                                         _F(OPERATION='RENOMME',
                                            NOM_PARA=(ch, chnew,),),
                                         ),)
        else:
            TMP_S = CALC_TABLE(TABLE=RESU[i],
                               TITRE=' ',
                               ACTION=(_F(OPERATION='EXTR',
                                          NOM_PARA=('INST', ch,),),
                                       _F(OPERATION='RENOMME',
                                          NOM_PARA=(ch, chnew,),),
                                       ),)
            R_SI[j] = CALC_TABLE(reuse=R_SI[j], TABLE=R_SI[j],
                                 TITRE=' ',
                                 ACTION=(_F(OPERATION='COMB',
                                            TABLE=TMP_S, NOM_PARA='INST',),
                                         ),)
            DETRUIRE(CONCEPT=_F(NOM=TMP_S,),)

    return R_SI
