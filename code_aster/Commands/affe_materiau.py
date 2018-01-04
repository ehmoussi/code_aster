# coding: utf-8

# Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

# person_in_charge: nicolas.sellenet@edf.fr

from ..Objects import MaterialOnMesh
from ..Utilities import force_list
from .ExecuteCommand import ExecuteCommand
from ..Objects import TemperatureInputVariable, GeometryInputVariable, CorrosionInputVariable
from ..Objects import IrreversibleDeformationInputVariable, ConcreteHydratationInputVariable
from ..Objects import IrradiationInputVariable, SteelPhasesInputVariable
from ..Objects import ZircaloyPhasesInputVariable, Neutral1InputVariable, Neutral2InputVariable
from ..Objects import ConcreteDryingInputVariable, TotalFluidPressureInputVariable
from ..Objects import VolumetricDeformationInputVariable


class MaterialAssignment(ExecuteCommand):
    """Assign the :class:`~code_aster.Objects.Material` properties on the
    :class:`~code_aster.Objects.Mesh` that creates a
    :class:`~code_aster.Objects.MaterialOnMesh` object.
    """
    command_name = "AFFE_MATERIAU"

    def create_result(self, keywords):
        """Initialize the :class:`~code_aster.Objects.Mesh`.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        mesh = None
        if keywords.has_key("MAILLAGE"):
            mesh = keywords["MAILLAGE"]
        else:
            mesh = keywords["MODELE"].getSupportMesh()
        self._result = MaterialOnMesh(mesh)

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        fkw = keywords["AFFE"]
        if isinstance(fkw, dict):
            self._addMaterial(fkw)
        elif type(fkw) in (list, tuple):
            for curDict in fkw:
                self._addMaterial(curDict)
        else:
            raise TypeError("Unexpected type: {0!r} {1}".format(fkw, type(fkw)))

        fkw = keywords.get("AFFE_COMPOR")
        if fkw != None:
            if isinstance(fkw, dict):
                self._addBehaviour(fkw)
            elif type(fkw) in (list, tuple):
                for curDict in fkw:
                    self._addBehaviour(curDict)
            else:
                raise TypeError("Unexpected type: {0!r} {1}".format(fkw, type(fkw)))

        mesh = None
        if keywords.has_key("MAILLAGE"):
            mesh = keywords["MAILLAGE"]
        else:
            mesh = keywords["MODELE"].getSupportMesh()
        fkw = keywords.get("AFFE_VARC")
        if fkw != None:
            if isinstance(fkw, dict):
                self._addInputVariable(fkw, mesh)
            elif type(fkw) in (list, tuple):
                for curDict in fkw:
                    self._addInputVariable(curDict, mesh)
            else:
                raise TypeError("Unexpected type: {0!r} {1}".format(fkw, type(fkw)))

        self._result.build()

    def _addBehaviour(self, fkw):
        kwTout = fkw.get("TOUT")
        kwGrMa = fkw.get("GROUP_MA")
        mater = fkw["COMPOR"]

        if kwTout != None:
            self._result.addBehaviourOnAllMesh(mater)
        elif kwGrMa != None:
            kwGrMa = force_list(kwGrMa)
            for grp in kwGrMa:
                self._result.addBehaviourOnGroupOfElements(mater, grp)
        else:
            raise TypeError("At least {0} or {1} is required"
                            .format("TOUT", "GROUP_MA"))

    def _addInputVariable(self, fkw, mesh):
        if fkw.get("EVOL") != None:
            raise TypeError("{0} not allowed".format("EVOL",))
        kwTout = fkw.get("TOUT")
        kwGrMa = fkw.get("GROUP_MA")
        nomVarc = fkw["NOM_VARC"]
        chamGd = fkw["CHAM_GD"]
        valeRef = fkw.get("VALE_REF")

        obj = None
        if nomVarc == "TEMP":
            obj = TemperatureInputVariable
        elif nomVarc == "GEOM":
            obj = GeometryInputVariable
        elif nomVarc == "CORR":
            obj = CorrosionInputVariable
        elif nomVarc == "IRRA":
            obj = IrreversibleDeformationInputVariable
        elif nomVarc == "HYDR":
            obj = ConcreteHydratationInputVariable
        elif nomVarc == "SECH":
            obj = IrradiationInputVariable
        elif nomVarc == "EPSA":
            obj = SteelPhasesInputVariable
        elif nomVarc == "M_ACIER":
            obj = ZircaloyPhasesInputVariable
        elif nomVarc == "M_ZIRC":
            obj = Neutral1InputVariable
        elif nomVarc == "NEUT1":
            obj = Neutral2InputVariable
        elif nomVarc == "NEUT2":
            obj = ConcreteDryingInputVariable
        elif nomVarc == "PTOT":
            obj = TotalFluidPressureInputVariable
        elif nomVarc == "DIVU":
            obj = VolumetricDeformationInputVariable
        else:
            raise TypeError("Input Variable not allowed")

        inputVar = obj(mesh)
        inputVar.setInputValuesField(chamGd)
        if valeRef != None: inputVar.setReferenceValue(valeRef)

        if kwTout != None:
            self._result.addInputVariableOnAllMesh(inputVar)
        elif kwGrMa != None:
            kwGrMa = force_list(kwGrMa)
            for grp in kwGrMa:
                self._result.addInputVariableOnGroupOfElements(inputVar, grp)
        else:
            raise TypeError("At least {0} or {1} is required"
                            .format("TOUT", "GROUP_MA"))

    def _addMaterial(self, fkw):
        kwTout = fkw.get("TOUT")
        kwGrMa = fkw.get("GROUP_MA")
        mater = fkw[ "MATER" ]

        for mater_i in mater:
            if kwTout != None:
                self._result.addMaterialOnAllMesh(mater_i)
            elif kwGrMa != None:
                kwGrMa = force_list(kwGrMa)
                for grp in kwGrMa:
                    self._result.addMaterialOnGroupOfElements(mater_i, grp)
            else:
                raise TypeError("At least {0} or {1} is required"
                                .format("TOUT", "GROUP_MA"))


AFFE_MATERIAU = MaterialAssignment.run
