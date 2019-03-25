# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
:py:class:`GeneralizedAssemblyMatrixDouble` --- Generalized Assembly matrix
****************************************************
"""

from libaster import GeneralizedAssemblyMatrixDouble
from libaster import GeneralizedAssemblyMatrixComplex

from ..Utilities import injector

_orig_getType = GeneralizedAssemblyMatrixDouble.getType


def VALM_triang2array(dict_VALM, dim, dtype=None):
    import numpy
    # stockage symetrique ou non (triang inf+sup)
    sym = len(dict_VALM) == 1
    triang_sup = numpy.array(dict_VALM[1])
    assert dim*(dim+1)/2 == len(triang_sup), \
            'Matrice non pleine : %d*(%d+1)/2 != %d' % (dim, dim, len(triang_sup))
    if sym:
        triang_inf = triang_sup
    else:
        triang_inf = numpy.array(dict_VALM[2])
    valeur=numpy.zeros([dim, dim], dtype=dtype)
    for i in range(1, dim+1):
        for j in range(1, i+1):
            k = i*(i-1)/2 + j
            valeur[i-1, j-1]=triang_inf[k-1]
            valeur[j-1, i-1]=triang_sup[k-1]
    return valeur

def VALM_diag2array(dict_VALM, dim, dtype=None):
    import numpy
    diag = numpy.array(dict_VALM[1])
    assert dim == len(diag), 'Dimension incorrecte : %d != %d' % (dim, len(diag))
    valeur=numpy.zeros([dim, dim], dtype=dtype)
    for i in range(dim):
        valeur[i,i] =  diag[i]
    return valeur

class ExtendedGeneralizedAssemblyMatrixComplex(injector(GeneralizedAssemblyMatrixComplex),
                                   GeneralizedAssemblyMatrixComplex):
    cata_sdj = "SD.sd_matr_asse_gene.sd_matr_asse_gene"

    def __getstate__(self):
        """Return internal state.

        Returns:
            dict: Internal state.
        """
        return (True, self.getGeneralizedDOFNumbering(), self.getModalBasis())

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (dict): Internal state.
        """
        if state[1] is not None:
            self.setGeneralizedDOFNumbering(state[1])
        if state[2] is not None:
            self.setModalBasis(state[2])

    def EXTR_MATR_GENE(self) :
        import numpy
        if not self.accessible():
            raise AsException("Erreur dans matr_asse_gene_c.EXTR_MATR_GENE en PAR_LOT='OUI'")

        desc = self.sdj.DESC.get()
        # On teste si le DESC de la matrice existe
        if not desc:
            raise AsException("L'objet matrice {0!r} n'existe pas"
                              .format(self.sdj.DESC.nomj()))
        desc = numpy.array(desc)
        # Si le stockage est plein
        if desc[2] == 2 :
            valeur = VALM_triang2array(self.sdj.VALM.get(), desc[1], complex)

        # Si le stockage est diagonal
        elif desc[2]==1 :
            valeur = VALM_diag2array(self.sdj.VALM.get(), desc[1], complex)

        # Sinon on arrete tout
        else:
            raise KeyError
        return valeur

    def RECU_MATR_GENE(self,matrice) :
        import numpy, aster
        if not self.accessible():
            raise AsException("Erreur dans matr_asse_gene_c.RECU_MATR_GENE en PAR_LOT='OUI'")

        numpy.asarray(matrice)
        ncham=self.get_name()
        desc = self.sdj.DESC.get()
        # On teste si le DESC de la matrice existe
        if not desc:
            raise AsException("L'objet matrice {0!r} n'existe pas"
                            .format(self.sdj.DESC.nomj()))
        desc = numpy.array(desc)
        numpy.asarray(matrice)

        # On teste si la dimension de la matrice python est 2
        if (len(numpy.shape(matrice)) != 2) :
            raise AsException("La dimension de la matrice est incorrecte ")

        # On teste si la taille de la matrice jeveux et python est identique
        if (tuple([desc[1],desc[1]]) != numpy.shape(matrice)) :
            raise AsException("La taille de la matrice est incorrecte ")

        # Si le stockage est plein
        if desc[2]==2 :
            taille=desc[1]*desc[1]/2.0+desc[1]/2.0
            tmpr=numpy.zeros([int(taille)])
            tmpc=numpy.zeros([int(taille)])
            for j in range(desc[1]+1):
                for i in range(j):
                    k=j*(j-1)/2+i
                    tmpr[k]=matrice[j-1,i].real
                    tmpc[k]=matrice[j-1,i].imag
            aster.putvectjev('%-19s.VALM' % ncham, len(tmpr), tuple((\
                            list(range(1,len(tmpr)+1)))),tuple(tmpr),tuple(tmpc),1)
        # Si le stockage est diagonal
        elif desc[2]==1 :
            tmpr=numpy.zeros(desc[1])
            tmpc=numpy.zeros(desc[1])
            for j in range(desc[1]):
                tmpr[j]=matrice[j,j].real
                tmpc[j]=matrice[j,j].imag
            aster.putvectjev('%-19s.VALM' % ncham,len(tmpr),tuple((\
                            list(range(1,len(tmpr)+1)))),tuple(tmpr),tuple(tmpc),1)
        # Sinon on arrete tout
        else:
            raise KeyError
        return

class ExtendedGeneralizedAssemblyMatrixDouble(injector(GeneralizedAssemblyMatrixDouble),
                                   GeneralizedAssemblyMatrixDouble):
    cata_sdj = "SD.sd_matr_asse_gene.sd_matr_asse_gene"

    def __getstate__(self):
        """Return internal state.

        Returns:
            dict: Internal state.
        """
        return (True, self.getGeneralizedDOFNumbering(), self.getModalBasis())

    def __setstate__(self, state):
        """Restore internal state.

        Arguments:
            state (dict): Internal state.
        """
        if state[1] is not None:
            self.setGeneralizedDOFNumbering(state[1])
        if state[2] is not None:
            self.setModalBasis(state[2])

    def EXTR_MATR(self, sparse=False):
        import numpy as NP
        if not self.accessible():
            raise Accas.AsException(
                "Erreur dans matr_asse_gene.EXTR_MATR en PAR_LOT='OUI'")
        refa = NP.array(self.sdj.REFA.get())
        ma = refa[0]
        nu = refa[1]
        stock = "diag" if self.sdj.DESC.get()[2]==1 else "full"
        valm = self.sdj.VALM.get()
        sym = len(valm) == 1
        if not sym:
            raise Accas.AsException(
                "Not implemented for non symetric matrix")
        dim = len(valm[1]) if stock=="diag" else int((-1+NP.sqrt(1+8*len(valm[1])))/2)
        if stock=="diag":
            return NP.diag(valm[1])
        else:
            def make_sym_matrix(n,vals,ntype):
                m = NP.zeros([n,n], dtype=ntype)
                xs,ys = NP.triu_indices(n)
                m[xs,ys] = vals
                m[ys,xs] = vals
                return m
            triang_sup = NP.array(valm[1])
            if type(valm[1][0]) == complex:
                ntype = complex
            else:
                ntype = float
            return make_sym_matrix(dim,triang_sup,ntype)

    def EXTR_MATR_GENE(self):
        if not self.accessible():
            raise AsException("Erreur dans matr_asse_gene.EXTR_MATR_GENE en PAR_LOT='OUI'")
        import numpy

        desc = self.sdj.DESC.get()
        # On teste si le DESC du vecteur existe
        if not desc:
            raise AsException("L'objet vecteur {0!r} n'existe pas"
                              .format(self.sdj.DESC.nomj()))
        desc = numpy.array(desc)

        # Si le stockage est plein
        if desc[2]==2:
            valeur = VALM_triang2array(self.sdj.VALM.get(), desc[1])

        # Si le stockage est diagonal
        elif desc[2]==1:
            valeur = VALM_diag2array(self.sdj.VALM.get(), desc[1])

        # Sinon on arrete tout
        else:
            raise KeyError
        return valeur

    def RECU_MATR_GENE(self,matrice) :
        import numpy, aster
        if not self.accessible():
            raise AsException("Erreur dans matr_asse_gene.RECU_MATR_GENE en PAR_LOT='OUI'")

        ncham=self.get_name()

        desc = self.sdj.DESC.get()
        # On teste si le DESC de la matrice existe
        if not desc:
            raise AsException("L'objet matrice {0!r} n'existe pas"
                            .format(self.sdj.DESC.nomj()))
        desc = numpy.array(desc)

        numpy.asarray(matrice)

        # On teste si la dimension de la matrice python est 2
        if (len(numpy.shape(matrice)) != 2) :
            raise AsException("La dimension de la matrice est incorrecte ")

        # On teste si les tailles des matrices jeveux et python sont identiques
        if (tuple([desc[1],desc[1]]) != numpy.shape(matrice)) :
            raise AsException("La taille de la matrice est incorrecte ")

        # Si le stockage est plein
        if desc[2]==2 :
            taille=desc[1]*desc[1]/2.0+desc[1]/2.0
            tmp=numpy.zeros([int(taille)])
            for j in range(desc[1]+1):
                for i in range(j):
                    k=j*(j-1)/2+i
                    tmp[k]=matrice[j-1,i]
            aster.putcolljev('%-19s.VALM' % ncham,len(tmp),tuple((\
            list(range(1,len(tmp)+1)))),tuple(tmp),tuple(tmp),1)
        # Si le stockage est diagonal
        elif desc[2]==1 :
            tmp=numpy.zeros(desc[1])
            for j in range(desc[1]):
                tmp[j]=matrice[j,j]
            aster.putcolljev('%-19s.VALM' % ncham,len(tmp),tuple((\
            list(range(1,len(tmp)+1)))),tuple(tmp),tuple(tmp),1)
        # Sinon on arrete tout
        else:
            raise KeyError
        return
