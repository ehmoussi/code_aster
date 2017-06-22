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

# person_in_charge: mathieu.courtois at edf.fr

"""
This module defines the visitor used to print the keywords in the CODE file.
"""

import os

from Noyau.N_ASSD import ASSD
from Noyau.N_types import force_list, is_float, is_int

from E_Visitor import JDCVisitor
from E_utils import repr_float

MCFACT_VIDE = '--'


class CodeVisitor(JDCVisitor):

    """Visitor to print the text of the keywords used.
    """

    def __init__(self, filename, with_default=True):
        """Initialization.
        filename : name of the testcase
        with_default : if True, visit the default values of undefined keywords
        """
        self.with_default = with_default
        self.fname = filename
        self.cmdname = None
        self.mcfact = MCFACT_VIDE
        self.mcsimp = None
        self.value = ''
        self.args = []

    def get_text(self):
        """Return the text"""
        # fmt = ' %-10s%-20s %-20s%-20s%-20s'
        # fmt = '%r,%r,%r,%r,%r'
        fmt = '%s %s %s %s %s'
        lines = [fmt % args for args in self.args]
        return os.linesep.join(lines)

    def _visit_etape(self, step, reuse):
        """Visit generic ETAPE objects."""
        self.cmdname = step.definition.nom
        self._visitMCCOMPO(step)

    def visitMCFACT(self, fact):
        """Visit the MCFACT object."""
        # print "visit MCFACT", fact.nom
        self.mcfact = fact.nom
        self._visitMCCOMPO(fact)
        self.mcfact = MCFACT_VIDE

    def add_args(self):
        """Add the keyword"""
        self.args.append(
            (self.fname, self.cmdname, self.mcfact, self.mcsimp, self.value))

    def visitMCSIMP(self, mcsimp):
        """Visit the MCSIMP object."""
        self.mcsimp = mcsimp.nom
        self.value = ''
        lval = force_list(mcsimp.valeur)
        as_list = (mcsimp.definition.max == '**' or mcsimp.definition.max > 1) \
            and mcsimp.definition.into is not None
        svalues = []
        for i, value in enumerate(lval):
            repr_value = ''
            if is_float(value):
                repr_value = repr_float(value)
            elif is_int(value):
                repr_value = str(value)
            elif type(value) in (str, unicode):
                repr_value = repr(value)
            svalues.append(repr_value)
        if as_list and len(svalues) == 1:
            svalues.append("")
        self.value = ", ".join(svalues)
        if as_list:
            self.value = "(%s)" % self.value
        if mcsimp.definition.into is None and mcsimp.valeur != mcsimp.definition.defaut:
            self.value = ''
        self.add_args()

    def visitASSD(self, sd):
        """Visit the ASSD object."""
