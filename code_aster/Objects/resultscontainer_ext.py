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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`ResultsContainer` --- Results container
**************************************************
"""

import aster
from libaster import ResultsContainer

from ..Utilities import injector


class ExtendedResultsContainer(injector(ResultsContainer), ResultsContainer):
    cata_sdj = "SD.sd_resultat.sd_resultat"

    # TODO if several models?!
    def __getstate__(self):
        """Return internal state.

        Returns:
            dict: Internal state.
        """
        return (True, self.getModel(), )

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (dict): Internal state.
        """
        if state[1] is not None:
            self.appendModelOnAllRanks(state[1])

    def LIST_VARI_ACCES (self):
        if not self.accessible():
            raise AsException("Erreur dans resultat.LIST_VARI_ACCES " +
                              "en PAR_LOT='OUI'")
        return aster.GetResu(self.get_name(), "VARI_ACCES")

    def LIST_PARA (self):
        if not self.accessible():
            raise AsException("Erreur dans resultat.LIST_PARA en PAR_LOT='OUI'")
        return aster.GetResu(self.get_name(), "PARAMETRES")
