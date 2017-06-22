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
from SD.sd_nume_ddl_gene import sd_nume_ddl_gene


class sd_cham_gene(AsBase):
    nomj = SDNom(fin=19)
    REFE = AsVK24(lonmax=2, )
    VALE = AsObject(
        genr='V', xous='S', type=Parmi('C', 'R'), ltyp=Parmi(16, 8), )
    DESC = AsVI(docu='VGEN', )

    def exists(self):
        # retourne "vrai" si la SD semble exister (et donc qu'elle peut etre
        # vérifiée)
        return self.REFE.exists

    # indirection vers NUME_DDL_GENE:
    def check_REFE(self, checker):
        if not self.exists():
            return
        refe = self.REFE.get_stripped()
        # ce test fait planter les verif de SD issues de DYNA_VIBRA//GENE + RECU_GENE
        # op0037 cree un refe[1]='$TRAN_GENE' bidon
        # if refe[1] in  ('$TRAN_GENE','$HARM_GENE') : return
        if refe[1]:
            sd2 = sd_nume_ddl_gene(refe[1])
            sd2.check(checker)
