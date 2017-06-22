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

from SD import *
from SD.sd_titre import sd_titre
from SD.sd_util import *


#----------------------------------------------------------------
# définition de 3 classes :
#  sd_formule        (objets python + jeveux)
#  sd_fonction_aster (objets jeveux)
#  sd_fonction       (chapeau des 2 classes précédentes)
#----------------------------------------------------------------


class sd_formule(AsBase):
#--------------------------------------
    nomj = SDNom(fin=19)
    PROL = AsVK24(lonmax=6, )
    NOVA = AsVK8()


class sd_fonction_aster(sd_titre):
#--------------------------------------
    nomj = SDNom(fin=19)
    PROL = AsVK24()
    VALE = AsObject(acces='NU', sd_stockage='CONTIG', modelong='VARIABLE',
                    type='R', xous=Parmi('S', 'X'), genr='V', ltyp=8, )
    PARA = Facultatif(AsVR())

    # existence possible de la SD :
    def exists(self):
        return self.PROL.exists

    def check_PROL(self, checker):
    #-------------------------------
        if not self.exists():
            return

        prol = self.PROL.get()
        assert prol, self
        typfon = prol[0].strip()
        assert typfon in (
            'CONSTANT', 'FONCTION', 'FONCT_C', 'NAPPE', 'INTERPRE'), prol
        # ltabul = True : la fonction est tabulée (et non interpretée)
        ltabul = typfon != 'INTERPRE'

        if typfon == 'NAPPE':
            assert len(prol) > 7, (prol, self)
        else:
            # tester que le prol[5] est bien le nom de la fonction
            assert len(prol) == 6, (prol, self)

        if ltabul:  # type d'interpolation
            interp = prol[1].strip()
            assert interp[:3] in ('NON', 'LIN', 'LOG'), prol
            assert interp[4:] in ('NON', 'LIN', 'LOG'), prol

        if ltabul:  # nom d'un paramètre
            para = prol[2].strip()
            assert para != '', prol

        assert prol[3].strip() != '', prol  # type du résultat

        if ltabul:  # prolongement à droite et à gauche
            prolgd = prol[4].strip()
            assert len(prolgd) == 2, prol
            assert prolgd[0] in ('E', 'C', 'L', 'I'), prol
            assert prolgd[1] in ('E', 'C', 'L', 'I'), prol

        if typfon == 'NAPPE':
            nf = (len(prol) - 7) / 2
            assert len(prol) == 7 + 2 * nf, prol
            # 1er paramètre de la nappe
            assert prol[6].strip() != '', prol

            for kf in range(nf):
                interp = prol[6 + 2 * kf + 1].strip()
                prolgd = prol[6 + 2 * kf + 2].strip()
                assert interp[:3] in ('NON', 'LIN', 'LOG'), prol
                assert interp[4:] in ('NON', 'LIN', 'LOG'), prol
                assert prolgd[0] in ('E', 'C', 'L', 'I'), prol
                assert prolgd[1] in ('E', 'C', 'L', 'I'), prol

    def check_VALE(self, checker):
    #-------------------------------
        if not self.exists():
            return

        prol = self.PROL.get()
        vale = self.VALE.get()
        typfon = prol[0].strip()

        if typfon == 'CONSTANT':
            assert len(vale) == 2, (vale, self)

        elif typfon == 'FONCTION':
            nbpt = len(vale) / 2
            assert len(vale) == 2 * nbpt, (vale, self)
            if nbpt > 1:
                assert sdu_monotone(vale[:nbpt]) in (-1, 1), (nbpt, vale, self)

        elif typfon == 'FONCT_C':
            nbpt = len(vale) / 3
            assert len(vale) == 3 * nbpt, (vale, self)
            if nbpt > 1:
                # print "AJACOT fonction=",self
                assert sdu_monotone(vale[:nbpt]) in (-1, 1), (nbpt, vale, self)

        elif typfon == 'NAPPE':
            nbfonc = len(vale.keys())
            for k in range(nbfonc):
                val1 = vale[k + 1]
                nbpt = len(val1) / 2
                assert len(val1) == 2 * nbpt, (val1, self)
                if nbpt > 1:
                    assert sdu_monotone(val1[:nbpt]) in (
                        -1, 1), (nbpt, val1, self)

    def check_NAPPE(self, checker):
    #-------------------------------
        if not self.exists():
            return

        prol = self.PROL.get()
        typfon = prol[0].strip()
        if typfon != 'NAPPE':
            return

        para = self.PARA.get()
        if len(para) > 1:
            assert sdu_monotone(para) in (0, 1), (para, self)
        vale = self.VALE.get()
        assert len(para) == len(vale.keys()), self


class sd_fonction(sd_titre):
#---------------------------
    nomj = SDNom(fin=19)
    PROL = AsVK24()
    NOVA = Facultatif(AsVK8())
    VALE = Facultatif(AsObject())
    PARA = Facultatif(AsVR())

    def check_1(self, checker):
        nom = self.nomj()[:19]
        if self.NOVA.exists:
            sd2 = sd_formule(nom)
        else:
            sd2 = sd_fonction_aster(nom)
        sd2.check(checker)
