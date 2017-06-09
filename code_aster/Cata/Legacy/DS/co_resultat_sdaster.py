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


class resultat_sdaster(ASSD):
   cata_sdj = "SD.sd_resultat.sd_resultat"

   def LIST_CHAMPS (self) :
      if not self.accessible():
         raise AsException("Erreur dans resultat.LIST_CHAMPS en PAR_LOT='OUI'")
      return aster.GetResu(self.get_name(), "CHAMPS")

   def LIST_NOM_CMP (self) :
      if not self.accessible():
         raise AsException("Erreur dans resultat.LIST_NOM_CMP en PAR_LOT='OUI'")
      return aster.GetResu(self.get_name(), "COMPOSANTES")

   def LIST_VARI_ACCES (self) :
      if not self.accessible():
         raise AsException("Erreur dans resultat.LIST_VARI_ACCES en PAR_LOT='OUI'")
      return aster.GetResu(self.get_name(), "VARI_ACCES")

   def LIST_PARA (self) :
      if not self.accessible():
         raise AsException("Erreur dans resultat.LIST_PARA en PAR_LOT='OUI'")
      return aster.GetResu(self.get_name(), "PARAMETRES")


class comb_fourier(resultat_sdaster): pass
class fourier_elas(resultat_sdaster): pass
class fourier_ther(resultat_sdaster): pass
class mult_elas(resultat_sdaster): pass
class mode_empi(resultat_sdaster): pass

# resultat_sdaster/evol_sdaster :
class evol_sdaster(resultat_sdaster): pass
class evol_char(evol_sdaster): pass
class evol_elas(evol_sdaster): pass
class evol_noli(evol_sdaster): pass
class evol_ther(evol_sdaster): pass
class evol_varc(evol_sdaster): pass
