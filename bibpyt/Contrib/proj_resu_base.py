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

# person_in_charge: albert.alarcon at edf.fr

from code_aster.Cata.Commons import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Syntax import *
from code_aster.Supervis.ExecuteCommand import ExecuteCommand
from code_aster.Objects import TransientGeneralizedResultsContainer

PROJ_RESU_BASE_CATA=OPER(nom="PROJ_RESU_BASE",op=  79,sd_prod=tran_gene,
                    fr=tr("Projection d'une sd resultat assemblee sur une base (modale ou de RITZ)"),
                    reentrant='n',
         BASE            =SIMP(statut='o',typ=(mode_meca,mode_gene) ),
         NUME_DDL_GENE   =SIMP(statut='o',typ=nume_ddl_gene ),
         TYPE_VECT       =SIMP(statut='f',typ='TXM',defaut="FORC"),
         RESU            =SIMP(statut='o',typ=dyna_trans),
)  ;

class ProjResuBase(ExecuteCommand):
    command_name = "PROJ_RESU_BASE"
    command_cata = PROJ_RESU_BASE_CATA

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = TransientGeneralizedResultsContainer()

PROJ_RESU_BASE = ProjResuBase.run
