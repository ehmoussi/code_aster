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

from SD.sd_matr_asse_com import sd_matr_asse_com
from SD.sd_nume_ddl_gene import sd_nume_ddl_gene


class sd_matr_asse_gene(sd_matr_asse_com):
#-----------------------------------------
    nomj = SDNom(fin=19)

    DESC = AsVI(lonmax=3,)

    def exists(self):
        return self.REFA.exists

    # indirection vers sd_nume_ddl à faire car FACT_LDLT modifie le
    # sd_nume_ddl_gene de la sd_matr_asse :
    def check_gene_REFA(self, checker):
        if not self.exists:
            return
        nom = self.REFA.get()[1]
        sd2 = sd_nume_ddl_gene(nom)
        sd2.check(checker)

    def check_gene_DESC(self, checker):
        if not self.exists:
            return
        desc = self.DESC.get()
        assert desc[0] == 2, desc
        nbvec = desc[1]
        assert nbvec > 0, desc
        type_sto = desc[2]
        assert type_sto in (1, 2, 3), desc
        valm = self.VALM.get()[1]
        n1 = len(valm)
        if type_sto == 1:
            # stockage diagonal
            assert n1 == nbvec, desc
        elif type_sto == 2:
            # stockage plein (mais symetrique) :
            assert n1 == nbvec * (nbvec + 1) / 2, desc
        elif type_sto == 3:
            # stockage quelconque :
            assert n1 >= nbvec
            assert n1 <= nbvec * (nbvec + 1) / 2, desc
