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

# person_in_charge: mathieu.courtois@edf.fr
"""
:py:class:`AssemblyMatrixDisplacementReal` --- Assembly matrix
****************************************************
"""

import numpy as NP

from libaster import (AssemblyMatrixDisplacementComplex,
                      AssemblyMatrixDisplacementReal)

from ..SD.sd_stoc_morse import sd_stoc_morse
from ..Utilities import injector
from .datastructure_ext import get_depends, set_depends

_orig_getType = AssemblyMatrixDisplacementReal.getType


@injector(AssemblyMatrixDisplacementReal)
class ExtendedAssemblyMatrixDisplacementReal(object):
    cata_sdj = "SD.sd_matr_asse.sd_matr_asse"

    def __getstate__(self):
        """Return internal state.

        Returns:
            list: Internal state.
        """
        return get_depends(self) + [self.getDOFNumbering(), ]

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (list): Internal state.
        """
        set_depends(self, state)
        if state[0]:
            self.setDOFNumbering(state[0])

    def getType(self):
        """Returns the type of the matrix object.

        .. todo:: This is a workaround to pass the case where the native
            implementation returns ``MATR_ASSE_DEPL_R_DEPL_R``.

        Returns:
            str: Type name of the matrix.
        """
        typ = _orig_getType(self).replace("_DEPL_R_DEPL_R", "_DEPL_R")
        return typ

    def EXTR_MATR(self, sparse=False, epsilon=None) :
        """Returns the matrix values as `numpy.array`.

        Arguments:
            sparse (bool): By default, the returned matrix is dense. If *True*
                the returned matrix is sparse.
            epsilon (float): Terms less than this value is considered null.
                By default, it is 10^-8 * the mean of the absolute values.
                Only used if *sparse=True*.

        Returns:
            misc: A single `numpy.array` of the dense matrix if *sparse=False*.
            Or if *sparse=True* a tuple `(data, rows, cols, dim)`. `data`
            contains the values, `rows` the rows indices, `cols` the columns
            indices and `dim` the number of terms.
        """
        refa = NP.array(self.sdj.REFA.get())
        ma = refa[0]
        nu = refa[1]
        smos = sd_stoc_morse(nu[:14]+'.SMOS')
        valm = self.sdj.VALM.get()
        smhc = smos.SMHC.get()
        smdi = smos.SMDI.get()
        sym = refa[8].strip() == "MS"
        dim = len(smdi)
        nnz = len(smhc)
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
            rows = NP.array(smhc) - 1
            diag = NP.array(smdi) - 1
            class SparseMatrixIterator:
                """classe d'itération pour la liste de la colonne"""
                def __init__(self):
                    self.jcol = 0
                    self.kterm = 0

                def __iter__(self):
                    return self

                def __next__(self):
                    if self.kterm == 0:
                        self.kterm += 1
                        return self.jcol
                    if diag[self.jcol] < self.kterm:
                        self.jcol += 1
                    self.kterm += 1
                    return self.jcol

            col_iter = SparseMatrixIterator()
            # generate the columns indices
            cols = NP.fromiter(col_iter, count=nnz, dtype=int)

            # diag is where "row == col"
            helper = rows - cols
            diag_indices = NP.where(helper == 0)[0]

            # transpose indices in 'inf' part and remove diagonal terms
            cols_inf = NP.delete(rows, diag_indices)
            rows_inf = NP.delete(cols, diag_indices)
            triang_inf = NP.delete(triang_inf, diag_indices)

            # join 'sup' and 'inf' parts
            rows = NP.concatenate((rows, rows_inf))
            cols = NP.concatenate((cols, cols_inf))
            data = NP.concatenate((triang_sup, triang_inf))

            if epsilon is None:
                epsilon = abs(data).mean() * 1e-8
            nulls = NP.where(abs(data) < epsilon)
            rows = NP.delete(rows, nulls)
            cols = NP.delete(cols, nulls)
            data = NP.delete(data, nulls)
            return data, rows, cols, dim
        else :
            data = NP.zeros([dim, dim], dtype=dtype)
            jcol = 1
            for kterm in range(1,nnz+1):
                ilig = smhc[kterm-1]
                if smdi[jcol-1] < kterm:
                    jcol += 1
                data[jcol-1, ilig-1] = triang_inf[kterm-1]
                data[ilig-1, jcol-1] = triang_sup[kterm-1]
            return data

@injector(AssemblyMatrixDisplacementComplex)
class ExtendedAssemblyMatrixDisplacementComplex(object):
    cata_sdj = "SD.sd_matr_asse.sd_matr_asse"

    def EXTR_MATR(self, sparse=False, epsilon=None) :
        """Returns the matrix values as `numpy.array`.

        Arguments:
            sparse (bool): By default, the returned matrix is dense. If *True*
                the returned matrix is sparse.
            epsilon (float): Terms less than this value is considered null.
                By default, it is 10^-8 * the mean of the absolute values.
                Only used if *sparse=True*.

        Returns:
            misc: A single `numpy.array` of the dense matrix if *sparse=False*.
            Or if *sparse=True* a tuple `(data, rows, cols, dim)`. `data`
            contains the values, `rows` the rows indices, `cols` the columns
            indices and `dim` the number of terms.
        """
        refa = NP.array(self.sdj.REFA.get())
        ma = refa[0]
        nu = refa[1]
        smos = sd_stoc_morse(nu[:14]+'.SMOS')
        valm = self.sdj.VALM.get()
        smhc = smos.SMHC.get()
        smdi = smos.SMDI.get()
        sym = refa[8].strip() == "MS"
        dim = len(smdi)
        nnz = len(smhc)
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
            rows = NP.array(smhc) - 1
            diag = NP.array(smdi) - 1
            class SparseMatrixIterator:
                """classe d'itération pour la liste de la colonne"""
                def __init__(self):
                    self.jcol = 0
                    self.kterm = 0

                def __iter__(self):
                    return self

                def __next__(self):
                    if self.kterm == 0:
                        self.kterm += 1
                        return self.jcol
                    if diag[self.jcol] < self.kterm:
                        self.jcol += 1
                    self.kterm += 1
                    return self.jcol

            col_iter = SparseMatrixIterator()
            # generate the columns indices
            cols = NP.fromiter(col_iter, count=nnz, dtype=int)

            # diag is where "row == col"
            helper = rows - cols
            diag_indices = NP.where(helper == 0)[0]

            # transpose indices in 'inf' part and remove diagonal terms
            cols_inf = NP.delete(rows, diag_indices)
            rows_inf = NP.delete(cols, diag_indices)
            triang_inf = NP.delete(triang_inf, diag_indices)

            # join 'sup' and 'inf' parts
            rows = NP.concatenate((rows, rows_inf))
            cols = NP.concatenate((cols, cols_inf))
            data = NP.concatenate((triang_sup, triang_inf))

            if epsilon is None:
                epsilon = abs(data).mean() * 1e-8
            nulls = NP.where(abs(data) < epsilon)
            rows = NP.delete(rows, nulls)
            cols = NP.delete(cols, nulls)
            data = NP.delete(data, nulls)
            return data, rows, cols, dim
        else :
            data = NP.zeros([dim, dim], dtype=dtype)
            jcol = 1
            for kterm in range(1,nnz+1):
                ilig = smhc[kterm-1]
                if smdi[jcol-1] < kterm:
                    jcol += 1
                data[jcol-1, ilig-1] = triang_inf[kterm-1]
                data[ilig-1, jcol-1] = triang_sup[kterm-1]
            return data
