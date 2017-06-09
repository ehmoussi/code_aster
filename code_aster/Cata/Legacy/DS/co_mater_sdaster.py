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


class mater_sdaster(ASSD):
   cata_sdj = "SD.sd_mater.sd_mater"

   def RCVALE(self, phenomene, nompar=(), valpar=(), nomres=(), stop=1):
      """Appel à la routine fortran RCVALE pour récupérer les valeurs des
      propriétés du matériau.
      """
      if not self.accessible():
         raise AsException("Erreur dans mater.RCVALE en PAR_LOT='OUI'")
      from Utilitai.Utmess import UTMESS
      # vérification des arguments
      if not type(nompar) in (list, tuple):
         nompar = [nompar,]
      if not type(valpar) in (list, tuple):
         valpar = [valpar,]
      if not type(nomres) in (list, tuple):
         nomres = [nomres,]
      nompar = tuple(nompar)
      valpar = tuple(valpar)
      nomres = tuple(nomres)
      if len(nompar) != len(valpar):
         vk1=', '.join(nompar)
         vk2=', '.join([repr(v) for v in valpar])
         UTMESS('F','SDVERI_4',valk=[vk1,vk2])
      if len(nomres) < 1:
         UTMESS('F', 'SDVERI_5')
      # appel à l'interface Python/C
      return aster.rcvale(self.nom, phenomene, nompar, valpar, nomres, stop)
