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

from SD import *

from SD.sd_nume_eqge import sd_nume_eqge
from SD.sd_nume_elim import sd_nume_elim
from SD.sd_stockage import sd_stockage


class sd_nume_ddl_gene(sd_stockage):
#---------------------------------------
    nomj = SDNom(fin=14)
    nume = Facultatif(sd_nume_eqge(SDNom(nomj='.NUME')))
                      # n'existe pas toujours : CALC_MATR_AJOU/fdlv106a
    ELIM = Facultatif(sd_nume_elim(SDNom(nomj='.ELIM')))
                      # n'existe pas toujours : ELIMINATION
