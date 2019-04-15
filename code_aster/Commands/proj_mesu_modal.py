# coding: utf-8

# Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: natacha.bereux@edf.fr

from ..Objects import TransientGeneralizedResultsContainer, HarmoGeneralizedResultsContainer
from ..Objects import GeneralizedModeContainer
from .ExecuteCommand import ExecuteCommand


class ProjMesuModal(ExecuteCommand):
    """Command PROJ_MESU_MODAL
    """
    command_name = "PROJ_MESU_MODAL"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        mesure = keywords["MODELE_MESURE"]["MESURE"]
        if mesure.getType() == "DYNA_TRANS":
            self._result = TransientGeneralizedResultsContainer()
        elif mesure.getType() == "DYNA_HARMO":
            self._result = HarmoGeneralizedResultsContainer()
        elif mesure.getType() == "MODE_MECA":
            self._result = GeneralizedModeContainer()
        elif mesure.getType() == "MODE_MECA_C":
            self._result = GeneralizedModeContainer()
        else:
            raise TypeError("Type not allowed")

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        base = keywords["MODELE_CALCUL"]["BASE"]
        if isinstance(self._result, TransientGeneralizedResultsContainer) or \
           isinstance(self._result, HarmoGeneralizedResultsContainer)  :
            self._result.setDOFNumbering(base.getDOFNumbering())
PROJ_MESU_MODAL = ProjMesuModal.run
