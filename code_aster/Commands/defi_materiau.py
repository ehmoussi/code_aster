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

from ..Objects import Material, GeneralMaterialBehaviour
from .ExecuteCommand import ExecuteCommand


class MaterialDefinition(ExecuteCommand):
    """Definition of the material properties.
    Returns a :class:`~code_aster.Objects.Material` object.
    """
    command_name = "DEFI_MATERIAU"

    def create_result(self, _):
        """Initialize the :class:`~code_aster.Objects.Material`.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Material.create()

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        classByName = self._byKeyword()
        for fkwName, fkw in keywords.iteritems():
            # only see factor keyword
            if not isinstance(fkw, dict):
                continue
            klass = classByName.get(fkwName)
            if not klass:
                raise NotImplementedError("Unsupported behaviour: '{0}'"
                                          .format(fkwName))
            matBehav = klass.create()
            for skwName, skw in fkw.iteritems():
                if type( skw ) is float:
                    iName = skwName.capitalize()
                    cRet = matBehav.setDoubleValue( iName, skw )
                    if not cRet:
                        print ValueError("Can not assign keyword '{1}'/'{0}' "
                                         "(as '{3}'/'{2}') "
                                         .format(skwName, fkwName, iName,
                                                 klass.__name__))
                else:
                    raise NotImplementedError("Unsupported type for keyword: "
                                              "{0} <{1}>"
                                              .format(skwName, type(skw)))
            self._result.addMaterialBehaviour( matBehav )

        self._result.build()

    @staticmethod
    def _byKeyword():
        """Build a dict of all behaviours subclasses, indexed by keyword.

        Returns:
            dict: Behaviour classes by keyword in DEFI_MATERIAU.
        """
        import code_aster.Objects as all_types
        objects = {}
        for name, obj in all_types.__dict__.items():
            if not isinstance(obj, type):
                continue
            if not issubclass(obj, GeneralMaterialBehaviour):
                continue
            key = obj.create().getAsterName()
            objects[key] = obj
        return objects


DEFI_MATERIAU = MaterialDefinition.run
