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

# person_in_charge: nicolas.sellenet@edf.fr

from ..Objects import GeneralizedModel
from ..Supervis.ExecuteCommand import ExecuteCommand


class GeneralizedModelDefinition(ExecuteCommand):
    """Command that creates the :class:`~code_aster.Objects.GeneralizedModel`"""
    command_name = "DEFI_MODELE_GENE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """

        self._result = GeneralizedModel()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        sousStruct = keywords.get("SOUS_STRUC")
        if type(sousStruct) not in (tuple, list):
            sousStruct = (sousStruct,)
        for occur in sousStruct:
            self._result.addDynamicMacroElement(occur["NOM"], occur["MACR_ELEM_DYNA"])


DEFI_MODELE_GENE = GeneralizedModelDefinition.run
