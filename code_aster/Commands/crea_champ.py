# coding: utf-8

# Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

from ..Objects import PCFieldOnMeshDouble, FieldOnNodesDouble, FieldOnElementsDouble
from ..Objects import FieldOnNodesComplex
from .ExecuteCommand import ExecuteCommand


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
        if (typ != "R" and typ != "F" or location not in ("CART_", "NOEU_", "ELGA_", "ELNO_")) \
            and not (typ == "C" and location == "NOEU_"):
            raise NotImplementedError("Type of field {0!r} not yet supported"
                                      .format(keywords["TYPE_CHAM"]))

        if location == "CART_":
            if keywords.has_key("MAILLAGE"):
                mesh = keywords["MAILLAGE"]
            else:
                mesh = keywords["MODELE"].getSupportMesh()
            self._result = PCFieldOnMeshDouble(mesh)
        elif location == "NOEU_":
            if typ == "C":
                self._result = FieldOnNodesComplex()
            else:
                self._result = FieldOnNodesDouble()
        else:
            # ELGA_
            self._result = FieldOnElementsDouble()
        numeDdl = keywords.get("NUME_DDL")
        if numeDdl is not None:
            self._result.setDescription(numeDdl)
        modele = keywords.get("MODELE")
        if modele is not None and location[:2] == "EL":
            self._result.setModel(modele)

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.update()


CREA_CHAMP = FieldCreator.run
