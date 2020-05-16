# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

from ..Objects import (ConcreteDryingExternalVariable,
                       ConcreteHydratationExternalVariable,
                       CorrosionExternalVariable, EvolutionParameter,
                       GeometryExternalVariable, ExternalVariablesConverter,
                       ExternalVariablesField, IrradiationExternalVariable,
                       IrreversibleDeformationExternalVariable, MaterialField,
                       MaterialFieldBuilder, Neutral1ExternalVariable,
                       Neutral2ExternalVariable, Neutral3ExternalVariable,
                       SteelPhasesExternalVariable, TemperatureExternalVariable,
                       TotalFluidPressureExternalVariable,
                       VolumetricDeformationExternalVariable,
                       ZircaloyPhasesExternalVariable)
from ..Supervis import ExecuteCommand
from ..Utilities import force_list


class MaterialAssignment(ExecuteCommand):
    """Assign the :class:`~code_aster.Objects.Material` properties on the
    :class:`~code_aster.Objects.Mesh` that creates a
    :class:`~code_aster.Objects.MaterialField` object.
    """
    command_name = "AFFE_MATERIAU"

    def create_result(self, keywords):
        """Initialize the :class:`~code_aster.Objects.Mesh`.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        mesh = None
        model = keywords.get("MODELE")
        if "MAILLAGE" in keywords:
            mesh = keywords["MAILLAGE"]
        else:
            mesh = model.getMesh()
        self._result = MaterialField(mesh)
        if model is not None:
            self._result.setModel(model)

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
        if fkw is not None:
            if isinstance(fkw, dict):
                self._addBehaviour(fkw)
            elif type(fkw) in (list, tuple):
                for curDict in fkw:
                    self._addBehaviour(curDict)
            else:
                raise TypeError("Unexpected type: {0!r} {1}".format(fkw, type(fkw)))

        mesh = None
        if "MAILLAGE" in keywords:
            mesh = keywords["MAILLAGE"]
        else:
            mesh = keywords["MODELE"].getMesh()

        externalVarOnMesh = ExternalVariablesField(mesh)
        fkw = keywords.get("AFFE_VARC")
        if fkw is not None:
            if isinstance(fkw, dict):
                self._addExternalVariable(externalVarOnMesh, fkw, mesh)
            elif type(fkw) in (list, tuple):
                for curDict in fkw:
                    self._addExternalVariable(externalVarOnMesh, curDict, mesh)
            else:
                raise TypeError("Unexpected type: {0!r} {1}".format(fkw, type(fkw)))

        varc = ["VARC_NEUT1", "VARC_NEUT2", "VARC_TEMP", "VARC_GEOM", "VARC_PTOT", "VARC_SECH",
                "VARC_HYDR", "VARC_CORR", "VARC_IRRA", "VARC_DIVU", "VARC_EPSA", "VARC_M_ACIER",
                "VARC_M_ZIRC"]
        externalVariableConverter = ExternalVariablesConverter()
        for varcName in varc:
            fkw = keywords[varcName]
            name1 = fkw["NOM_VARC"]
            name2 = fkw["GRANDEUR"]
            comp1 = fkw["CMP_VARC"]
            comp2 = fkw["CMP_GD"]
            if type(comp1) is str:
                comp1 = [comp1]
            if type(comp1) is tuple:
                comp1 = list(comp1)
            if type(comp2) is str:
                comp2 = [comp2]
            if type(comp2) is tuple:
                comp2 = list(comp2)
            externalVariableConverter.addConverter(name1, comp1, name2, comp2)

        self._result = MaterialFieldBuilder.build(self._result, externalVarOnMesh,
                                                   externalVariableConverter)

    def _addBehaviour(self, fkw):
        kwTout = fkw.get("TOUT")
        kwGrMa = fkw.get("GROUP_MA")
        mater = fkw["COMPOR"]

        if kwTout is not None:
            self._result.addBehaviourOnAllMesh(mater)
        elif kwGrMa is not None:
            kwGrMa = force_list(kwGrMa)
            for grp in kwGrMa:
                self._result.addBehaviourOnGroupOfCells(mater, grp)
        else:
            raise TypeError("At least {0} or {1} is required"
                            .format("TOUT", "GROUP_MA"))

    def _addExternalVariable(self, externalVarOnMesh, fkw, mesh):
        kwTout = fkw.get("TOUT")
        kwGrMa = fkw.get("GROUP_MA")
        kwMail = fkw.get("MAILLE")
        nomVarc = fkw["NOM_VARC"]
        chamGd = fkw.get("CHAM_GD")
        valeRef = fkw.get("VALE_REF")
        evol = fkw.get("EVOL")

        obj = None
        if nomVarc == "TEMP":
            obj = TemperatureExternalVariable
        elif nomVarc == "GEOM":
            obj = GeometryExternalVariable
        elif nomVarc == "CORR":
            obj = CorrosionExternalVariable
        elif nomVarc == "EPSA":
            obj = IrreversibleDeformationExternalVariable
        elif nomVarc == "HYDR":
            obj = ConcreteHydratationExternalVariable
        elif nomVarc == "IRRA":
            obj = IrradiationExternalVariable
        elif nomVarc == "M_ACIER":
            obj = SteelPhasesExternalVariable
        elif nomVarc == "M_ZIRC":
            obj = ZircaloyPhasesExternalVariable
        elif nomVarc == "NEUT1":
            obj = Neutral1ExternalVariable
        elif nomVarc == "NEUT2":
            obj = Neutral2ExternalVariable
        elif nomVarc == "NEUT3":
            obj = Neutral3ExternalVariable
        elif nomVarc == "SECH":
            obj = ConcreteDryingExternalVariable
        elif nomVarc == "PTOT":
            obj = TotalFluidPressureExternalVariable
        elif nomVarc == "DIVU":
            obj = VolumetricDeformationExternalVariable
        else:
            raise TypeError("Input Variable not allowed")

        externalVar = obj(mesh)
        if valeRef is not None:
            externalVar.setReferenceValue(valeRef)

        if chamGd is not None:
            externalVar.setInputValuesField(chamGd)

        if evol is not None:
            evolParam = EvolutionParameter(evol)
            nomCham = fkw.get("NOM_CHAM")
            if nomCham is not None: evolParam.setFieldName(nomCham)
            foncInst = fkw.get("FONC_INST")
            if foncInst is not None: evolParam.setTimeFunction(foncInst)

            prolDroite = fkw.get("PROL_DROITE")
            if prolDroite is not None:
                if prolDroite == "EXCLU":
                    evolParam.prohibitRightExtension()
                if prolDroite == "CONSTANT":
                    evolParam.setConstantRightExtension()
                if prolDroite == "LINEAIRE":
                    evolParam.setLinearRightExtension()

            prolGauche = fkw.get("PROL_GAUCHE")
            if prolGauche is not None:
                if prolGauche == "EXCLU":
                    evolParam.prohibitLeftExtension()
                if prolGauche == "CONSTANT":
                    evolParam.setConstantLeftExtension()
                if prolGauche == "LINEAIRE":
                    evolParam.setLinearLeftExtension()

            externalVar.setEvolutionParameter(evolParam)

        if kwTout is not None:
            externalVarOnMesh.addExternalVariableOnAllMesh(externalVar)
        elif kwMail is not None:
            kwMail = force_list(kwMail)
            for elem in kwMail:
                externalVarOnMesh.addExternalVariableOnElement(externalVar, elem)
        elif kwGrMa is not None:
            kwGrMa = force_list(kwGrMa)
            for grp in kwGrMa:
                externalVarOnMesh.addExternalVariableOnGroupOfCells(externalVar, grp)
        else:
            externalVarOnMesh.addExternalVariableOnAllMesh(externalVar)

    def _addMaterial(self, fkw):
        kwTout = fkw.get("TOUT")
        kwGrMa = fkw.get("GROUP_MA")
        kwMail = fkw.get("MAILLE")
        mater = fkw["MATER"]
        if type(mater) is not list:
            mater = list(mater)

        if kwTout is not None:
            self._result.addMaterialsOnAllMesh(mater)
        elif kwGrMa is not None:
            kwGrMa = force_list(kwGrMa)
            self._result.addMaterialsOnGroupOfCells(mater, kwGrMa)
        elif kwMail is not None:
            kwMail = force_list(kwMail)
            self._result.addMaterialsOnCell(mater, kwMail)
        else:
            raise TypeError("At least {0}, {1} or {2} is required"
                            .format("TOUT", "GROUP_MA", "MAILLE"))


AFFE_MATERIAU = MaterialAssignment.run
