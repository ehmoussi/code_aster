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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`Function` --- Function object
****************************************
"""

import traceback
from pickle import dumps, loads

from libaster import Formula

from ..Utilities import force_list, initial_context, injector, logger


@injector(Formula)
class ExtendedFormula(object):
    cata_sdj = "SD.sd_fonction.sd_formule"

    def __getstate__(self):
        """Return internal state.

        Returns:
            dict: Internal state.
        """
        init = initial_context()
        user_ctxt = {}
        for key, val in self.getContext().items():
            if val is not init.get(key):
                user_ctxt[key] = val
        return self.getExpression(), dumps(user_ctxt)

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (dict): Internal state.
        """
        assert len(state) == 2, state
        self.setExpression(state[0])
        # try to load the context
        try:
            ctxt = initial_context()
            ctxt.update(loads(state[1]))
            self.setContext(ctxt)
        except:
            logger.warning("can not restore context of formula '{0}'"
                        .format(self.getName()))
            logger.debug(traceback.format_exc())

    def __call__(self, *val):
        """Evaluate the formula with the given variables values.

        Arguments:
            val (list[float]): List of the values of the variables.

        Returns:
            float/complex: Value of the formula for these values.
        """
        result = self.evaluate(force_list(val))
        if self.getType() == "FORMULE_C":
            result = complex(*result)
        else:
            result = result[0]
        return result

    def Parametres(self):
        """Return a dict containing the properties of the formula that can be
        directly passed to CALC_FONC_INTERP.

        Same method exists for real and complex function.

        Returns:
            dict: Dict of properties.
        """
        dico = {
            'INTERPOL': ['LIN', 'LIN'],
            'NOM_PARA': self.getVariables(),
            'NOM_RESU': self.getProperties()[3],
            'PROL_DROITE': "EXCLU",
            'PROL_GAUCHE': "EXCLU",
        }
        return dico
