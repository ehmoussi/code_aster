# coding: utf-8

# Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

from ..Objects import FullTransientResultsContainer, FullHarmonicResultsContainer
from ..Objects import TransientGeneralizedResultsContainer, HarmoGeneralizedResultsContainer
from ..Objects import MechanicalModeContainer, GeneralizedModeContainer
from .ExecuteCommand import ExecuteCommand


class RestGenePhys(ExecuteCommand):
    """Command REST_GENE_PHYS
    """
    command_name = "REST_GENE_PHYS"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if isinstance(keywords["RESU_GENE"], TransientGeneralizedResultsContainer):
            self._result = FullTransientResultsContainer()
        elif isinstance(keywords["RESU_GENE"], HarmoGeneralizedResultsContainer):
            self._result = FullHarmonicResultsContainer()
        elif isinstance(keywords["RESU_GENE"], GeneralizedModeContainer):
            self._result = MechanicalModeContainer()
        else:
            raise Exception("Unknown result type")

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        resu_gene = keywords["RESU_GENE"]
        if isinstance(resu_gene, (TransientGeneralizedResultsContainer,
                                    HarmoGeneralizedResultsContainer)):
            dofNum = resu_gene.getDOFNumbering()
            if dofNum is not None:
                self._result.setDOFNumbering(dofNum)
                self._result.appendModelOnAllRanks(dofNum.getModel())
        elif isinstance(resu_gene, GeneralizedModeContainer):
            matrRigi = resu_gene.getStiffnessMatrix()
            if matrRigi is not None:
                modalBasis = matrRigi.getModalBasis()
                dofNum = modalBasis.getDOFNumbering()
                if dofNum is not None:
                    self._result.setDOFNumbering(dofNum)
        else:
            raise Exception("Unknown result type")


REST_GENE_PHYS = RestGenePhys.run
