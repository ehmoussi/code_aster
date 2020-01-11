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

# person_in_charge: nicolas.greffet at edf.fr


from ...Cata.Syntax import PROC, SIMP
from ...Supervis import ExecuteCommand

INIT_COMPO_CATA = PROC(nom="INIT_COMPO",
                op=  117,
                fr=tr("Initialiser adresse component YACS"),
           COMPO           =SIMP(statut='o',typ='I',),
)

class InitComponent(ExecuteCommand):
    """Command that initialize a code_aster component.
    """
    command_name = "INIT_COMPO"
    command_cata = INIT_COMPO_CATA

INIT_COMPO = InitComponent.run
