# coding: utf-8

# Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: mathieu.courtois@edf.fr

from ..Objects import (FullHarmonicResultsContainer,
                       FullTransientResultsContainer,
                       HarmoGeneralizedResultsContainer,
                       TransientGeneralizedResultsContainer)
from ..Supervis.ExecuteCommand import ExecuteCommand


class FourierTransformation(ExecuteCommand):
    """Command that creates the :class:`~code_aster.Objects.EvolutiveThermalLoad` by assigning
    finite elements on a :class:`~code_aster.Objects.EvolutiveThermalLoad`."""
    command_name = "REST_SPEC_TEMP"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        input = keywords.get('RESULTAT') or keywords['RESU_GENE']
        if isinstance(input, FullHarmonicResultsContainer):
            self._result = FullTransientResultsContainer()
        elif isinstance(input, FullTransientResultsContainer):
            self._result = FullHarmonicResultsContainer()
        elif isinstance(input, HarmoGeneralizedResultsContainer):
            self._result = TransientGeneralizedResultsContainer()
        elif isinstance(input, TransientGeneralizedResultsContainer):
            self._result = HarmoGeneralizedResultsContainer()
        else:
            raise TypeError("unsupported input type: {0}".format(input))


REST_SPEC_TEMP = FourierTransformation.run
