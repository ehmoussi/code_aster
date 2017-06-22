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


# sd_partition (utilisee par la sd_modele) :
#--------------------------------------------
class sd_partition(AsBase):
    nomj = SDNom(fin=8)
    PRTI = AsVI(lonmax=1)
    PRTK = AsVK24(lonmax=2)

    # si PRTK(1) in ('MAIL_DISPERSE', 'MAIL_CONTIGU') :
    NUPROC_MAILLE = Facultatif(AsVI(SDNom(nomj='.NUPROC.MAILLE')))

    def check_1(self, checker):
        prti = self.PRTI.get()
        assert prti[0] > 0, prti

        prtk = self.PRTK.get_stripped()
        assert prtk[0] in (
            'SOUS_DOM.OLD', 'GROUP_ELEM', 'SOUS_DOMAINE', 'MAIL_DISPERSE', 'MAIL_CONTIGU'), prtk

        if prtk[0] in ( 'SOUS_DOM.OLD', 'SOUS_DOMAINE' ):
            assert prtk[1] != '', prtk
            sd2 = sd_partit(prtk[1])
            sd2.check(checker)
        else:
            assert prtk[1] == '', prtk

        if prtk[0] in ('MAIL_DISPERSE', 'MAIL_CONTIGU'):
            assert self.NUPROC_MAILLE.exists


# sd_partit :
#----------------------------------------------------
class sd_partit(AsBase):
    nomj = SDNom(fin=19)
    FDIM = AsVI(lonmax=1, )
    FREF = AsVK8(lonmax=1, )
    FETA = AsColl(acces='NO', stockage='DISPERSE',
                  modelong='VARIABLE', type='I', )
