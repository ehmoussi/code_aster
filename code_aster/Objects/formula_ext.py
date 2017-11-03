# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

from __future__ import division

import pickle

from libaster import Formula

from ..Utilities import accept_array, deprecated


class injector(object):
    class __metaclass__(Formula.__class__):
        def __init__(self, name, bases, dict):
            for b in bases:
                if type(b) not in (self, type):
                    for k, v in dict.items():
                        setattr(b, k, v)
            return type.__init__(self, name, bases, dict)


def initial_context():
    """Returns `initial` Python context (independent of Stage and Command)

    Returns:
        dict: pairs of name per corresponding Python instance.
    """
    import math
    context = {}
    for func in dir(math):
        if not func.startswith('_'):
            context[func] = getattr(math, func)

    return context

class ExtendedFormula(injector, Formula):
    cata_sdj = "SD.sd_fonction.sd_formule"
    code = None
    _initial_context = initial_context()

    def __call__(self, *val):
        """Evaluation of the formula.

        Arguments:
            val (list[float]): List of the values of the parameters.

        Returns:
            float: Value of the formula for these parameters.
        """
        if not self.code:
            expr = self.getExpression()
            self.code = compile(expr, expr, "eval")
        context = {}
        ctxt = self.getContext()
        if ctxt:
            context.update(pickle.loads(ctxt))
        for param, value in zip(self.getVariables(), val):
            context[param] = value
        try:
            value = eval(self.code, context, self._initial_context)
        except Exception, exc:
            raise ValueError("Error evaluating the formula {0!r}:\n{1}".format(
                self.getExpression(), str(exc)))
        return value

    @property
    @deprecated(help="Use 'getVariables()' instead.")
    def nompar(self):
        """Return the variables names."""
        return self.getVariables()


class FormulaC(Formula):
    """Complex formula."""
