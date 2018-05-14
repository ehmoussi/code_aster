# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois@edf.fr

from .ExecuteCommand import ExecuteCommandOps


class DefineUnitFile(ExecuteCommandOps):
    """Execute legacy operator DEFI_FICHIER."""
    command_name = "DEFI_FICHIER"
    command_op = 26

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        from code_aster.RunManager.LogicalUnit import LogicalUnitFile, FileType, FileAccess, Action
        if keywords["ACTION"] in ("ASSOCIER", "RESERVER"):
            action = Action.value(keywords["ACTION"])
            typ = FileType.value(keywords["TYPE"])
            access = FileAccess.value(keywords["ACCES"])
            file_name = keywords.get("FICHIER")
            #if file_name == None:
                #file_name = ""
            newFile = LogicalUnitFile(keywords["UNITE"], file_name, action,
                                      typ, access, False)
        if keywords["ACTION"] == "LIBERER":
            LogicalUnitFile.release_from_number(keywords["UNITE"], False)

DEFI_FICHIER = DefineUnitFile.run
