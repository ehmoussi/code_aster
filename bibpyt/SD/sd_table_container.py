# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

from SD.sd_table import sd_table
from SD.sd_vect_elem import sd_vect_elem
from SD.sd_matr_elem import sd_matr_elem
from SD.sd_cham_elem import sd_cham_elem
from SD.sd_cham_no import sd_cham_no
# from SD.sd_mode_meca import sd_mode_meca
from SD.sd_dyna_phys import sd_dyna_phys
from SD.sd_fonction import sd_fonction
# --------------------------------------------------------------------
# sd_table contenant les colonnes nommée "NOM_OBJET","TYPE_OBJET",
# et "NOM_SD"
# --------------------------------------------------------------------


class sd_table_container(sd_table):
#-------------------------------------
    nomj = SDNom(fin=19)

    def check_table_container(self, checker):

        # vérification de l'existence de la table
        if not self.exists():
            checker.err(self, "La sd_table_container %s ne semble"
                        "pas exister" % (self.nomj()))

        # on vérifie la présence des paramètres
        # 'NOM_OBJET','TYPE_OBJET','NOM_SD'
        param = ['NOM_OBJET', 'TYPE_OBJET', 'NOM_SD']
        shape = self.TBNP.get()
        assert shape[0] > 2  # la table à au moins 3 paramètres
        for n in param:
            col, dummy = self.get_column_name(n)
            if col is None:
                checker.err(self, "Paramètre %s manquant!" % (n))

            # on vérifie que les colonnes ne sont pas vides
            data = col.data.get()
            if data is not None:
                if col.data.lonuti != shape[1]:
                    checker.err(self, "Taille inconsistante %d!=%d" %
                                (col.data.lonuti, shape[1]))

        # on vérifie le contenu de la colonne NOM_SD
        col1, dummy = self.get_column_name('TYPE_OBJET')
        col2, dummy = self.get_column_name('NOM_SD')
        # CARA_CHOC pour MODE_NON_LINE
        col3, dummy = self.get_column_name('CARA_CHOC')
        nbli = col1.data.lonuti
        lnom1 = col1.data.get_stripped()
        lnom2 = col2.data.get_stripped()
        if col3 is not None:
            lnom3 = col3.data.get_stripped()
        for k in range(nbli):
            if lnom1[k].startswith("VECT_ELEM"):
                sd5 = sd_vect_elem(lnom2[k])
                sd5.check(checker)
            elif lnom1[k].startswith("MATR_ELEM"):
                sd5 = sd_matr_elem(lnom2[k])
                sd5.check(checker)
            elif lnom1[k].startswith("CHAM_ELEM"):
                sd5 = sd_cham_elem(lnom2[k])
                sd5.check(checker)
            elif lnom1[k].startswith("MODE_MECA"):
                sd5 = sd_dyna_phys(lnom2[k])
                sd5.check(checker)
                if col3 is not None:
                # si CARA_CHOC existe, on vérifie que son contenu est une table
                    sdc = sd_table(lnom3[k])
                    sdc.check(checker)
            elif lnom1[k].startswith("FONCTION"):
                sd5 = sd_fonction(lnom2[k])
                sd5.check(checker)
            elif lnom1[k].startswith("FONCTION_C"):
                sd5 = sd_fonction(lnom2[k])
                sd5.check(checker)
            elif lnom1[k].startswith("NAPPE"):
                sd5 = sd_fonction(lnom2[k])
                sd5.check(checker)
            elif lnom1[k].startswith("CHAM_NO"):
                sd5 = sd_cham_no(lnom2[k])
                sd5.check(checker)
            elif lnom1[k].startswith("TABLE"):
                sd5 = sd_table(lnom2[k])
                sd5.check(checker)
            else:
                assert 0, lnom1[k]
