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

from ..Objects import (LoadResult, ThermalResult,
                       FieldOnNodesComplex, FieldOnNodesReal,
                       ElasticFourierResult, ThermalFourierResult,
                       FullHarmonicResult,
                       FullTransientResult,
                       ExternalVariablesResult,
                       ElasticResult,
                       ModeResultComplex, ModeResult,
                       MultipleElasticResult, NonLinearResult)
from ..Supervis import ExecuteCommand


class ResultCreator(ExecuteCommand):
    """Command that creates evolutive results."""
    command_name = "CREA_RESU"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if "reuse" in keywords:
            self._result = keywords["reuse"]
        else:
            typ = keywords["TYPE_RESU"]
            if typ == "EVOL_CHAR":
                self._result = LoadResult()
            elif typ == "EVOL_THER":
                self._result = ThermalResult()
            elif typ == "EVOL_NOLI":
                self._result = NonLinearResult()
            elif typ == "EVOL_ELAS":
                self._result = ElasticResult()
            elif typ == "EVOL_VARC":
                self._result = ExternalVariablesResult()
            elif typ == "FOURIER_ELAS":
                self._result = ElasticFourierResult()
            elif typ == "FOURIER_THER":
                self._result = ElasticFourierResult()
            elif typ == "MULT_ELAS":
                self._result = MultipleElasticResult()
            elif typ == "MODE_MECA":
                self._result = ModeResult()
            elif typ == "MODE_MECA_C":
                self._result = ModeResultComplex()
            elif typ == "DYNA_TRANS":
                self._result = FullTransientResult()
            elif typ == "DYNA_HARMO":
                self._result = FullHarmonicResult()
            else:
                raise NotImplementedError("Type of result {0!r} not yet "
                                        "implemented".format(typ))

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        fkw = keywords.get("AFFE")
        if fkw is not None:
            if type(fkw) not in (list, tuple): fkw = fkw,
            for occ in fkw:
                chamGd = occ.get("CHAM_GD")
                if chamGd is not None:
                    isFieldOnNodesReal = isinstance(chamGd, FieldOnNodesReal)
                    isFieldOnNodesComplex = isinstance(chamGd, FieldOnNodesComplex)
                    if isFieldOnNodesReal or isFieldOnNodesComplex:
                        mesh = chamGd.getMesh()
                        if mesh is not None:
                            self._result.setMesh(mesh)
                            break
        if fkw is None:
            fkw = keywords.get("ASSE")
        if fkw is None:
            fkw = keywords.get("PREP_VRC2")
        if fkw is None:
            fkw = keywords.get("PREP_VRC1")
        if fkw is not None:
            chamMater = fkw[0].get("CHAM_MATER")
            if chamMater is not None:
                self._result.appendMaterialFieldOnAllRanks(chamMater)

            modele = fkw[0].get("MODELE")
            chamGd = fkw[0].get("CHAM_GD")
            result = fkw[0].get("RESULTAT")

            if modele is not None:
                self._result.appendModelOnAllRanks(modele)
            elif result is not None:
                modele = result.getModel()
                if modele is not None:
                    self._result.appendModelOnAllRanks(modele)

                mesh = result.getMesh()
                if mesh is not None:
                    self._result.setMesh(mesh)
            elif chamGd is not None:
                try:
                    modele = chamGd.getModel()
                    self._result.appendModelOnAllRanks(modele)
                except:
                    pass
                try:
                    mesh = chamGd.getMesh()
                    self._result.setMesh(mesh)
                except:
                    pass

        self._result.update()

    def add_dependencies(self, keywords):
        """Register input *DataStructure* objects as dependencies.

        Arguments:
            keywords (dict): User's keywords.
        """
        super().add_dependencies(keywords)
        self.remove_dependencies(keywords, "AFFE", "CHAM_GD")
        self.remove_dependencies(keywords, "ASSE", "RESULTAT")
        self.remove_dependencies(keywords, "ECLA_PG", "RESU_INIT")
        if keywords["OPERATION"] == "PERM_CHAM":
            self.remove_dependencies(keywords, "RESU_INIT")
            self.remove_dependencies(keywords, "RESU_FINAL")
        self.remove_dependencies(keywords, "PROL_RTZ", "TABLE")
        self.remove_dependencies(keywords, "PREP_VRC1", "CHAM_GD")
        self.remove_dependencies(keywords, "PREP_VRC2", "ELAS_THER")
        self.remove_dependencies(keywords, "KUCV", "RESU_INIT")
        self.remove_dependencies(keywords, "CONV_RESU", "RESU_INIT")


CREA_RESU = ResultCreator.run
