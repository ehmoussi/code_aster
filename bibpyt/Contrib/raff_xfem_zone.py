# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

# person_in_charge: samuel.geniaut at edf.fr

# commande cachee appelee uniquement par la macro RAFF_XFEM

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *
from code_aster.Objects import PCFieldOnMeshDouble
from code_aster.Commands.ExecuteCommand import ExecuteCommand


RAFF_XFEM_ZONE_CATA=OPER(nom="RAFF_XFEM_ZONE",
                         op=188,
#                    sd_prod=cham_elem,
                         sd_prod=carte_sdaster,
                         fr=tr("Calcul d'un indicateur binaire pour le raffinement"),
                         reentrant='n',

                         FISSURE=SIMP(statut='o',typ=fiss_xfem,min=1,max=1),
                         RAYON  =SIMP(statut='o',typ='R',val_min=0.),

                         )  ;

class RaffXfemZone(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.XfemCrack`.
    """
    command_name = "RAFF_XFEM_ZONE"
    command_cata = RAFF_XFEM_ZONE_CATA

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = PCFieldOnMeshDouble(keywords["FISSURE"].getMesh())


RAFF_XFEM_ZONE = RaffXfemZone.run
