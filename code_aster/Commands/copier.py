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

from ..Objects import Model, PrestressingCableDefinition, ResultsContainer
from ..Supervis.ExecuteCommand import ExecuteCommand


class Copier(ExecuteCommand):
    """Command COPIER
    """
    command_name = "COPIER"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        other = keywords['CONCEPT']
        if isinstance(other, PrestressingCableDefinition):
            self._result = PrestressingCableDefinition(
                other.getModel(),
                other.getMaterialOnMesh(),
                other.getElementaryCharacteristics())
        elif isinstance(other, ResultsContainer):
            # do not support several models
            mesh = other.getModel().getMesh()
            self._result = type(other)()
            self._result.setMesh(mesh)
        else:
            self._result = type(other)()

    def post_exec(self, keywords):
        """
        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if isinstance(self._result, Model):
            self._result.setMesh(keywords['CONCEPT'].getMesh())


COPIER = Copier.run
