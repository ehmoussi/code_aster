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

from ..Objects import (FieldOnCellsReal, FieldOnNodesComplex,
                       FieldOnNodesReal, FullResult,
                       ConstantFieldOnCellsReal)
from ..Supervis import ExecuteCommand


class FieldCreator(ExecuteCommand):
    """Command that creates fields that may be
    :class:`~code_aster.Objects.FieldOnNodesReal` or
    :class:`~code_aster.Objects.ConstantFieldOnCellsReal`."""
    command_name = "CREA_CHAMP"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        location = keywords["TYPE_CHAM"][:5]
        typ = keywords["TYPE_CHAM"][10:]

        mesh = keywords.get("MAILLAGE")
        model = keywords.get("MODELE")
        caraElem = keywords.get("CARA_ELEM")
        charge = keywords.get("CHARGE")
        resultat = keywords.get("RESULTAT")
        if mesh is None:
            if model is not None:
                mesh = model.getMesh()
            elif caraElem is not None:
                mesh = caraElem.getModel().getMesh()
            elif charge is not None:
                mesh = charge.getModel().getMesh()
            elif resultat is not None:
                mesh = resultat.getMesh()

        if location == "CART_":
            if mesh is None:
                raise NotImplementedError("Must have Mesh, Model or ElementaryCharacteristics")
            self._result = ConstantFieldOnCellsReal(mesh)
        elif location == "NOEU_":
            if typ == "C":
                self._result = FieldOnNodesComplex()
            else:
                self._result = FieldOnNodesReal()
            if mesh is not None:
                self._result.setMesh(mesh)
        else:
            # ELGA_
            self._result = FieldOnCellsReal()
        numeDdl = keywords.get("NUME_DDL")
        if numeDdl is not None:
            self._result.setDOFNumbering(numeDdl)
        modele = keywords.get("MODELE")
        if location[:2] == "EL":
            modele = keywords.get("MODELE")
            chamF = keywords.get("CHAM_F")
            if modele is not None:
                self._result.setModel(modele)
            elif resultat is not None:
                if isinstance(resultat, FullResult):
                    try:
                        dofNum = resultat.getDOFNumbering()
                        self._result.setDescription(dofNum.getFiniteElementDescriptors()[0])
                    except:
                        pass
                if resultat.getModel() is not None:
                    self._result.setModel(resultat.getModel())
            elif caraElem is not None:
                self._result.setModel(caraElem.getModel())
            elif chamF is not None:
                self._result.setModel(chamF.getModel())

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.update()

    def add_dependencies(self, keywords):
        """Register input *DataStructure* objects as dependencies.

        Arguments:
            keywords (dict): User's keywords.
        """
        super().add_dependencies(keywords)
        self.remove_dependencies(keywords, "ASSE", "CHAM_GD")
        self.remove_dependencies(keywords, "COMB", "CHAM_GD")

        if keywords["OPERATION"] in ("ASSE_DEPL", "R2C", "C2R", "DISC"):
            self.remove_dependencies(keywords, "CHAM_GD")

        self.remove_dependencies(keywords, "EVAL", ("CHAM_F", "CHAM_PARA"))

        if keywords["OPERATION"] == "EXTR":
            # depends on "result".LIGREL
            # self.remove_dependencies(keywords, "RESULTAT")
            self.remove_dependencies(keywords, "FISSURE")
            self.remove_dependencies(keywords, "TABLE")
            self.remove_dependencies(keywords, "CARA_ELEM")
            self.remove_dependencies(keywords, "CHARGE")


CREA_CHAMP = FieldCreator.run
