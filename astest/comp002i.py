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


def TEST_ECART(ch_param2, label_cal, N_pas, Ncal, ch_param, R_SI, prec_ecart, prec_zero, C_Pa):
    # Exploitations
    CH_V1 = ['INST']
    for ch in ch_param2:
    # CALCUL des ecarts relatifs
        i = ch_param2.index(ch)
        chref1 = ch + label_cal[4] + str(N_pas[4])
        chref2 = ch + label_cal[Ncal - 1] + str(N_pas[Ncal - 1])
        chref = [chref1, chref2]

        for j in range(Ncal):
            coef = 1.
            ch_cal = ch + label_cal[j] + str(N_pas[j])
            ch_err = 'ER_' + ch_cal
            if j < 4:
                if (j == 0 and i > 0 and i < 9):
                    coef = 1 / C_Pa
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
            R_SI[i] = CALC_TABLE(TABLE=R_SI[i], reuse=R_SI[i],
                                 TITRE='R_SI' + str(j),
                                 ACTION=(_F(OPERATION='OPER', NOM_PARA=ch_err,
                                            FORMULE=ERR_REL),
                                         ),)
            DETRUIRE(CONCEPT=_F(NOM=ERR_REL,),)

        for j in range(Ncal):
            ch_cal = ch + label_cal[j] + str(N_pas[j])
            ch_err = 'ER_' + ch_cal
            TEST_TABLE(TABLE=R_SI[i], NOM_PARA=ch_err,
                       TYPE_TEST='MAX',
                       VALE_CALC=0.,
                       TOLE_MACHINE=prec_ecart[j],
                       VALE_REFE=0.,
                       CRITERE='ABSOLU',
                       PRECISION=prec_ecart[j],
                       REFERENCE='ANALYTIQUE',)

    return
