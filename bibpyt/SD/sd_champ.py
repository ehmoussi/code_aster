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

from SD.sd_cham_no import sd_cham_no
from SD.sd_cham_elem import sd_cham_elem
from SD.sd_cham_gene import sd_cham_gene
from SD.sd_carte import sd_carte
from SD.sd_resuelem import sd_resuelem

#---------------------------------------------------------------------------------
# classe "chapeau" à sd_cham_no, sd_cham_elem, sd_carte, ...
#-------------------------------------------------------------------------


class sd_champ(AsBase):
#---------------------------
    nomj = SDNom(fin=19)

    def check_champ_1(self, checker):
        # est-ce  un sd_cham_no, un sd_cham_elem, ... ?
        nom = self.nomj()[:19]
        nom1 = nom + '.CELD'
        iexi = aster.jeveux_exists(nom1)
        if iexi:
            nom2 = nom + '.CELD'
        else:
            nom2 = nom + '.DESC'
            iexi2 = aster.jeveux_exists(nom2)
            if not iexi2:
                if not self.optional and not checker.optional:
                    checker.err(self, "n'existe pas (%r)" % self._parent)
                return

        docu = aster.jeveux_getattr(nom2, 'DOCU')[1].strip()
        if docu == 'CHNO':
            sd2 = sd_cham_no(nom)
        elif docu == 'CART':
            sd2 = sd_carte(nom)
        elif docu == 'CHML':
            sd2 = sd_cham_elem(nom)
        elif docu == 'RESL':
            sd2 = sd_resuelem(nom)
        elif docu == 'VGEN':
            sd2 = sd_cham_gene(nom)
        else:
            assert 0, docu
        sd2.check(checker)

# sd des cham_no


class sd_cham_no_class(sd_champ, sd_cham_no):
    pass

# sd des cham_elem


class sd_cham_elem_class(sd_champ, sd_cham_elem):
    pass

# sd des cartes


class sd_carte_class(sd_champ, sd_carte):
    pass
