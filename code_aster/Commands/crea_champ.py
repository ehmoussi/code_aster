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

from ..Objects import PCFieldOnMeshDouble, FieldOnNodesDouble, FieldOnElementsDouble
from ..Objects import FieldOnNodesComplex, FullResultsContainer
from ..Supervis.ExecuteCommand import ExecuteCommand


class FieldCreator(ExecuteCommand):
    """Command that creates fields that may be
    :class:`~code_aster.Objects.FieldOnNodesDouble` or
    :class:`~code_aster.Objects.PCFieldOnMeshDouble`."""
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
            self._result = PCFieldOnMeshDouble(mesh)
        elif location == "NOEU_":
            if typ == "C":
                self._result = FieldOnNodesComplex()
            else:
                self._result = FieldOnNodesDouble()
            if mesh is not None:
                self._result.setMesh(mesh)
        else:
            # ELGA_
            self._result = FieldOnElementsDouble()
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
                if isinstance(resultat, FullResultsContainer):
                    try:
                        dofNum = resultat.getDOFNumbering()
                        self._result.setDescription(dofNum.getFiniteElementDescriptors()[0])
                    except: pass
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


CREA_CHAMP = FieldCreator.run
