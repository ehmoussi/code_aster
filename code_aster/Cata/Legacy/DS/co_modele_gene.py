# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois at edf.fr


import aster
from code_aster.Cata.Syntax import ASSD, AsException


class modele_gene(ASSD):
   cata_sdj = "SD.sd_modele_gene.sd_modele_gene"

   def LIST_SOUS_STRUCT(self) :
      """ retourne la liste des sous structures du modele generalise
         la liste des macro-elements sous-jacents"""
      if not self.accessible():
         raise AsException("Erreur dans modele_gene.LIST_SOUS_STRUCT en PAR_LOT='OUI'")
      nommodgen=self.get_name()
      ncham=nommodgen+(8-len(nommodgen))*' '
      ssno=aster.getvectjev(ncham+(14-len(ncham))*' '+'.MODG.SSNO')
      ssme=aster.getcolljev(ncham+(14-len(ncham))*' '+'.MODG.SSME')
      return [([ssno[ind], ssme[ind+1]]) for ind in range(len(ssno))]

   def LIST_LIAIS_STRUCT(self) :
      """ retourne la liste des liaisons entre sous structures du modele generalise sous la forme :
         [ (ss1, nom_liais1,  ss2 , nom_liais2), ...] """
      if not self.accessible() :
         raise AsException("Erreur dans modele_gene.LIST_LIAIS_STRUCT en PAR_LOT='OUI'")
      nommodgen=self.get_name()
      ncham=nommodgen+(8-len(nommodgen))*' '
      lidf=aster.getcolljev(ncham+(14-len(ncham))*' '+'.MODG.LIDF')
      return [([(lidf[ind][indb]) for indb in range(4)]) for ind in lidf]
