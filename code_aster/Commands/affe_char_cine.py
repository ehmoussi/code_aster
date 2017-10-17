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

from libaster import getGlossary
from ..Objects import KinematicsLoad
from .ExecuteCommand import ExecuteCommand


class KinematicsLoadDefinition(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.KinematicsLoad`."""
    command_name = "AFFE_CHAR_CINE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = KinematicsLoad.create()
        self._result.setSupportModel(keywords["MODELE"])

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        fkwMecaImpo = keywords.get( "MECA_IMPO" )
        if fkwMecaImpo != None:
            if type( fkwMecaImpo ) == tuple:
                for curDict in fkwMecaImpo:
                    self._addLoad(curDict, "MECA_IMPO")
            elif type( fkwMecaImpo ) == dict:
                self._addLoad(fkwMecaImpo, "MECA_IMPO")

        fkwTherImpo = keywords.get("THER_IMPO")
        if fkwTherImpo != None:
            if type( fkwTherImpo ) == tuple:
                for curDict in fkwTherImpo:
                    self._addLoad(curDict, "THER_IMPO")
            elif type( fkwTherImpo ) == dict:
                self._addLoad(fkwTherImpo, "THER_IMPO")

        fkwAcouImpo = keywords.get("ACOU_IMPO")
        if fkwAcouImpo != None:
            if type( fkwAcouImpo ) == tuple:
                for curDict in fkwAcouImpo:
                    self._addLoad(curDict, "ACOU_IMPO")
            elif type( fkwAcouImpo ) == dict:
                self._addLoad(fkwAcouImpo, "ACOU_IMPO")

        fkwEvolImpo = keywords.get("EVOL_IMPO")
        if fkwEvolImpo != None:
            raise NotImplementedError("{0!r} is not yet implemented"
                                      .format("EVOL_IMPO"))

        self._result.build()

    def _addLoad(self, fkwImpo, nameOfImpo ):
        glossary = getGlossary()

        kwTout = None
        kwGroupMa = None
        kwGroupNo = None
        for key, value in fkwImpo.iteritems():
            if key in ("TOUT", "NOEUD", "MAILLE"):
                raise NameError( key + " not permitted" )
            elif key == "GROUP_MA":
                kwGroupMa = fkwImpo.get( "GROUP_MA" )
            elif key == "GROUP_NO":
                kwGroupNo = fkwImpo.get( "GROUP_NO" )

        for key, value in fkwImpo.iteritems():
            if key not in ( "GROUP_MA", "GROUP_NO" ):
                component = glossary.getComponent( key )
                if kwTout != None:
                    raise NameError("Load on all mesh is not available")
                elif kwGroupMa != None:
                    if nameOfImpo == "MECA_IMPO":
                        self._result.addImposedMechanicalDOFOnElements(
                            component, value, kwGroupMa )
                    elif nameOfImpo == "THER_IMPO":
                        self._result.addImposedThermalDOFOnElements(
                            component, value, kwGroupMa )
                    elif nameOfImpo == "ACOU_IMPO":
                        self._result.addImposedAcousticDOFOnElements(
                            component, value, kwGroupMa )
                elif kwGroupNo != None:
                    if nameOfImpo == "MECA_IMPO":
                        self._result.addImposedMechanicalDOFOnNodes(
                            component, value, kwGroupNo )
                    elif nameOfImpo == "THER_IMPO":
                        self._result.addImposedThermalDOFOnNodes(
                            component, value, kwGroupMa )
                    elif nameOfImpo == "ACOU_IMPO":
                        self._result.addImposedAcousticDOFOnNodes(
                            component, value, kwGroupMa )


AFFE_CHAR_CINE = KinematicsLoadDefinition()
