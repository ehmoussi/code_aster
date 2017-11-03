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

from libaster import Formula

from ..Utilities import deprecated, force_list


class injector(object):
    class __metaclass__(Formula.__class__):
        def __init__(self, name, bases, dict):
            for b in bases:
                if type(b) not in (self, type):
                    for k, v in dict.items():
                        setattr(b, k, v)
            return type.__init__(self, name, bases, dict)


class ExtendedFormula(injector, Formula):
    cata_sdj = "SD.sd_fonction.sd_formule"

    def __call__(self, *val):
        """Evaluation of the formula.

        Arguments:
            val (list[float]): List of the values of the parameters.

        Returns:
            float: Value of the formula for these parameters.
        """
        return self.evaluate(force_list(val))

    @property
    @deprecated(help="Use 'getVariables()' instead.")
    def nompar(self):
        """Return the variables names."""
        return self.getVariables()


class FormulaC(Formula):
    """Complex formula."""
