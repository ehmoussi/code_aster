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

from ..Supervis import ExecuteCommand


class ComputeAdditionalField(ExecuteCommand):
    """Command that computes additional fields in a
    :class:`~code_aster.Objects.Result`.
    """
    command_name = "CALC_CHAMP"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if "reuse" in keywords:
            self._result = keywords["reuse"]
        else:
            self._result = type(keywords["RESULTAT"])()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if "reuse" not in keywords:
            modele = keywords.get("MODELE")
            if modele is None:
                try:
                    modele = keywords["RESULTAT"].getModel()
                except:
                    modele = None
            if modele is None:
                try:
                    modele = keywords["RESULTAT"].getDOFNumbering().getModel()
                except:
                    modele = None
            if modele is not None:
                self._result.appendModelOnAllRanks(modele)

            try:
                dofNume = keywords["RESULTAT"].getDOFNumbering()
            except:
                dofNume = None

            if dofNume is not None:
                self._result.setDOFNumbering(dofNume)
        else:
            try:
                modele = self._result.getModel()
            except:
                modele = None

            if modele is None:
                modele = keywords.get("MODELE")

            if modele is not None:
                self._result.appendModelOnAllRanks(modele)

        self._result.update()

    def add_dependencies(self, keywords):
        """Register input *DataStructure* objects as dependencies.

        Do not keep reference to RESULTAT (if not reused).

        Arguments:
            keywords (dict): User's keywords.
        """
        super().add_dependencies(keywords)
        self.remove_dependencies(keywords, "RESULTAT")
        if "reuse" not in keywords:
            # only if there is only one model, fieldmat...
            try:
                model = keywords["RESULTAT"].getModel()
                if model:
                    self._result.addDependency(model)
            except RuntimeError:
                pass
            try:
                fieldmat = keywords["RESULTAT"].getMaterialField()
                if fieldmat:
                    self._result.addDependency(fieldmat)
            except RuntimeError:
                pass
            try:
                elem = keywords["RESULTAT"].getElementaryCharacteristics()
                if elem:
                    self._result.addDependency(elem)
            except RuntimeError:
                pass


CALC_CHAMP = ComputeAdditionalField.run
