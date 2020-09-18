# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
from code_aster.Commands import CALC_TABLE, DETRUIRE, FORMULE, TEST_TABLE
from code_aster.MacroCommands.Utils.testcomp_utils import relative_error


def TEST_ECART(ch_param2, label_cal, N_pas, Ncal, nbequi, R_SI, prec_ecart, prec_zero, coef_para):
    # CALCUL des ecarts relatifs
    CH_V1 = ['INST']
    for ch in ch_param2:
        i = ch_param2.index(ch)
        chref1 = ch + label_cal[nbequi] + str(N_pas[nbequi])
        chref2 = ch + \
            label_cal[Ncal - nbequi + 1] + str(N_pas[Ncal - nbequi + 1])
        chref = [chref1, chref2]
        # chref1 utilisé pour les calculs équivalents, chref2 pour la
        # discretisation en temps
        for j in range(Ncal):
            coef = 1.0
            ch_cal = ch + label_cal[j] + str(N_pas[j])
            ch_err = 'ER_' + ch_cal
            if j < nbequi:
                if (j == 0):
                    coef = 1 / coef_para[i]
                iref = 0
            else:
                iref = 1
                if (i == 0):
                    CH_V1.append(ch_cal)
#               calcul de l'erreur (ecart relatif)
            preczero = prec_zero[i]
            ch_for = 'relative_error(' + ch_cal + ',' + chref[
                iref] + ',' + str(coef) + ',' + str(preczero) + ')'
            ERR_REL = FORMULE(NOM_PARA=(ch_cal, chref[iref]),
                              VALE = ch_for,
                              relative_error=relative_error)
            R_SI[i] = CALC_TABLE(
                TABLE=R_SI[i], reuse=R_SI[i], TITRE='R_SI' + str(j),
                      ACTION=(_F(OPERATION='OPER', NOM_PARA=ch_err, FORMULE=ERR_REL),),)
            DETRUIRE(CONCEPT=_F(NOM=ERR_REL,),)
        for j in range(Ncal):
            ch_cal = ch + label_cal[j] + str(N_pas[j])
            ch_err = 'ER_' + ch_cal
            TEST_TABLE(TABLE=R_SI[i],
                       NOM_PARA=ch_err, REFERENCE='ANALYTIQUE',
                       TYPE_TEST='MAX',
                       VALE_CALC=0,
                       VALE_REFE=0,
                       CRITERE='ABSOLU',
                       TOLE_MACHINE=prec_ecart[j],
                       PRECISION=prec_ecart[j],)
    return
