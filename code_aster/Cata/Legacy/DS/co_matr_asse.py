# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
# Copyright (C) 2014 STEFAN H. REITERER stefan.harald.reiterer@gmail.com
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


class matr_asse(ASSD):
    cata_sdj = "SD.sd_matr_asse.sd_matr_asse"

    def EXTR_MATR(self, sparse=False) :
        """Retourne les valeurs de la matrice dans un format numpy
        Si sparse=True, la valeur de retour est un triplet de numpy.array.
        Attributs retourne si sparse=False:
        - valeurs : numpy.array contenant les valeurs
        ou si sparse=True:
        - valeurs : numpy.array contenant les valeurs
        - lignes : numpy.array numpy.array contenant les indices des lignes
        - colonnes : numpy.array contenant les indices des colonnes
        - dim : int qui donne la dimension de la matrice
        """
        import numpy as NP
        from SD.sd_stoc_morse import sd_stoc_morse
        if not self.accessible():
            raise AsException("Erreur dans matr_asse.EXTR_MATR en PAR_LOT='OUI'")
        refa = NP.array(self.sdj.REFA.get())
        ma = refa[0]
        nu = refa[1]
        smos = sd_stoc_morse(nu[:14]+'.SMOS')
        valm = self.sdj.VALM.get()
        smhc = smos.SMHC.get()
        smdi = smos.SMDI.get()
        sym = len(valm) == 1
        dim = len(smdi)
        nnz = smdi[dim-1]
        triang_sup = NP.array(valm[1])
        if sym:
            triang_inf = triang_sup
        else:
            triang_inf = NP.array(valm[2])
        if type(valm[1][0]) == complex:
            dtype = complex
        else :
            dtype = float

        if sparse :
            smhc = NP.array(smhc)-1
            smdi = NP.array(smdi)-1
            class SparseMatrixIterator :
                """classe d'itération pour la liste de la colonne"""
                def __init__(self) :
                    self.jcol=0
                    self.kterm=0

                def __iter__(self) :
                    return self

                def next(self) :
                    if self.kterm == 0:
                        self.kterm += 1
                        return self.jcol
                    if smdi[self.jcol] < self.kterm:
                        self.jcol += 1
                    self.kterm += 1
                    return self.jcol

            col_iter = SparseMatrixIterator()
            # générer la liste de colonnes
            cols = NP.fromiter(col_iter, count=nnz, dtype=int)
            # entrées filtre de pivot de triang_inf
            helper = smhc - cols
            indices_to_filter = NP.where(helper == 0)[0]
            smdi_inf = NP.copy(smhc)
            smdi_inf = NP.delete(smdi_inf, indices_to_filter)
            smhc_inf = NP.copy(cols)
            smhc_inf = NP.delete(smhc_inf, indices_to_filter)
            triang_inf = NP.delete(triang_inf, indices_to_filter)
            # joindre les listes
            lignes = NP.concatenate((cols,smdi_inf))
            colonnes = NP.concatenate((smhc,smhc_inf))
            valeurs = NP.concatenate((triang_sup, triang_inf))
            return valeurs, lignes, colonnes, dim
        else :
            valeur = NP.zeros([dim, dim], dtype=dtype)
            jcol = 1
            for kterm in xrange(1,nnz+1):
                ilig=smhc[kterm-1]
                if smdi[jcol-1] < kterm:
                    jcol += 1
                valeur[jcol-1,ilig-1] = triang_inf[kterm-1]
                valeur[ilig-1,jcol-1] = triang_sup[kterm-1]
            return valeur

class matr_asse_gd(matr_asse):
    cata_sdj = "SD.sd_matr_asse.sd_matr_asse"

class matr_asse_depl_c(matr_asse_gd):
    pass

class matr_asse_depl_r(matr_asse_gd):
    pass

class matr_asse_pres_c(matr_asse_gd):
    pass

class matr_asse_pres_r(matr_asse_gd):
    pass

class matr_asse_temp_c(matr_asse_gd):
    pass

class matr_asse_temp_r(matr_asse_gd):
    pass
