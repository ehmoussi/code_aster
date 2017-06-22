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

# Il NE faudrait utiliser cette fonction QUE sur des tableaux hétérogènes.
# Pour les tableaux homogènes (int, float, string), utiliser numpy.transpose.

def transpose(liste):
    """Transposition de double liste
    """
    import numpy
    if isinstance(liste, numpy.ndarray):
        from warnings import warn
        warn('prefer use of numpy.transpose instead',
             DeprecationWarning, stacklevel=2)

    n = range(len(liste[0]))
    m = range(len(liste))
    liste_t = [[] for i in n]
    for i in n:
        for j in m:
            liste_t[i].append(liste[j][i])
    return liste_t
