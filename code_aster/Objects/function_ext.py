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
:py:class:`Function` --- Function object
****************************************
"""

import os
from math import pi

import numpy as NP

import aster
from libaster import Function, FunctionComplex

from ..Utilities import accept_array, injector
from .function_py import t_fonction, t_fonction_c
from .table_graph import Graph


@injector(Function)
class ExtendedFunction(object):
    cata_sdj = "SD.sd_fonction.sd_fonction_aster"

    setValues = accept_array(Function.setValues)

    def abs(self):
        """Return the absolute value of the function.

        Returns:
            (Function): Absolute value of the function.
        """
        new = Function()
        absc, ordo = self.Valeurs()
        new.setValues(absc, NP.abs(ordo))
        return new

    def getValuesAsArray(self):
        """Return the values of the function as a `numpy.array` of shape (N, 2).

        Returns:
            numpy.array: Array containing the values.
        """
        size = self.size()
        values = NP.array(self.getValues())
        values.shape = (2, size)
        return values.transpose()

    def convert(self, arg='real'):
        """
        Retourne un objet de la classe t_fonction
        représentation python de la fonction
        """
        class_fonction = t_fonction
        if arg == 'complex':
            class_fonction = t_fonction_c
        absc, ordo = self.Valeurs()
        return class_fonction(absc, ordo, self.Parametres(), nom=self.getName())

    def Valeurs(self):
        """
        Retourne deux listes de valeurs : abscisses et ordonnees
        """
        values = self.getValuesAsArray()
        return values[:, 0], values[:, 1]

    def Absc(self):
        """Retourne la liste des abscisses"""
        return self.Valeurs()[0]

    def Ordo(self):
        """Retourne la liste des ordonnées"""
        return self.Valeurs()[1]

    def __call__(self, val, tol=1.e-6):
        """Evaluate a function at 'val'. If provided, 'tol' is a relative
        tolerance to match an abscissa value."""
        try:
            val = val.valeur
        except AttributeError:
            val = float(val)
        __ff = self.convert()
        return __ff(val, tol=tol)

    def Parametres(self):
        """
        Retourne un dictionnaire contenant les parametres de la fonction ;
        le type jeveux (FONCTION, FONCT_C, NAPPE) n'est pas retourne,
        le dictionnaire peut ainsi etre fourni a CALC_FONC_INTERP tel quel.
        """
        TypeProl = {'E': 'EXCLU', 'L': 'LINEAIRE', 'C': 'CONSTANT'}
        objev = '%-19s.PROL' % self.getName()
        prol = self.sdj.PROL.get()
        dico = {
            'INTERPOL': [prol[1][0:3], prol[1][4:7]],
            'NOM_PARA': prol[2][0:16].strip(),
            'NOM_RESU': prol[3][0:16].strip(),
            'PROL_DROITE': TypeProl[prol[4][1]],
            'PROL_GAUCHE': TypeProl[prol[4][0]],
        }
        return dico

    def Trace(self, FORMAT='TABLEAU', **kargs):
        """Tracé d'une fonction"""
        gr = Graph()
        para = self.Parametres()
        gr.AjoutCourbe(
            Val=self.Valeurs(),
            Lab=[para['NOM_PARA'], para['NOM_RESU']],
            Leg=os.linesep.join(self.sdj.TITR.get() or []))
        gr.Trace(FORMAT=FORMAT, **kargs)



@injector(FunctionComplex)
class ExtendedFunctionComplex(object):
    cata_sdj = "SD.sd_fonction.sd_fonction_aster"

    setValues = accept_array(FunctionComplex.setValues)

    def getValuesAsArray(self):
        """Return the values of the function as a `numpy.array` of shape (N, 3).

        Returns:
            numpy.array: Array containing the values.
        """
        size = self.size()
        values = NP.array(self.getValues())
        abscissas = values[:size].transpose()
        ordinates = values[size:].transpose()
        abscissas.shape = (size, 1)
        ordinates.shape = (size, 2)
        ordinates = ordinates
        return NP.hstack([abscissas, ordinates])

    def Valeurs(self):
        """
        Retourne trois listes de valeurs : abscisses, parties reelles et imaginaires.
        """
        values = self.getValuesAsArray()
        return values[:, 0], values[:, 1], values[:, 2]

    def Absc(self):
        """Retourne la liste des abscisses"""
        return self.Valeurs()[0]

    def Ordo(self):
        """Retourne la liste des parties réelles des ordonnées"""
        return self.Valeurs()[1]

    def OrdoImg(self):
        """Retourne la liste des parties imaginaires des ordonnées"""
        return self.Valeurs()[2]

    def convert(self, arg='real'):
        """
        Retourne un objet de la classe t_fonction ou t_fonction_c,
        représentation python de la fonction complexe
        """
        class_fonction = t_fonction
        if arg == 'complex':
            class_fonction = t_fonction_c
        absc = self.Absc()
        para = self.Parametres()
        if arg == 'real':
            ordo = self.Ordo()
        elif arg == 'imag':
            ordo = self.OrdoImg()
        elif arg == 'modul':
            ordo = numpy.sqrt(
                numpy.array(self.Ordo())**2 + numpy.array(self.OrdoImg())**2)
        elif arg == 'phase':
            ordo = numpy.arctan2(
                numpy.array(self.OrdoImg()), numpy.array(self.Ordo())) * 180. / pi
        elif arg == 'complex':
            ordo = list(map(complex, self.Ordo(), self.OrdoImg()))
        else:
            assert False, 'unexpected value for arg: %r' % arg
        return class_fonction(self.Absc(), ordo, self.Parametres(), nom=self.getName())

    def __call__(self, val, tol=1.e-6):
        """Evaluate a function at 'val'. If provided, 'tol' is a relative
        tolerance to match an abscissa value."""
        try:
            val = val.valeur
        except AttributeError:
            val = float(val)
        __ff = self.convert(arg='complex')
        return __ff(val, tol=tol)

    def Parametres(self):
        """
        Retourne un dictionnaire contenant les parametres de la fonction ;
        le type jeveux (FONCTION, FONCT_C, NAPPE) n'est pas retourne,
        le dictionnaire peut ainsi etre fourni a CALC_FONC_INTERP tel quel.
        """
        TypeProl = {'E': 'EXCLU', 'L': 'LINEAIRE', 'C': 'CONSTANT'}
        objev = '%-19s.PROL' % self.getName()
        prol = self.sdj.PROL.get()
        dico = {
            'INTERPOL': [prol[1][0:3], prol[1][4:7]],
            'NOM_PARA': prol[2][0:16].strip(),
            'NOM_RESU': prol[3][0:16].strip(),
            'PROL_DROITE': TypeProl[prol[4][1]],
            'PROL_GAUCHE': TypeProl[prol[4][0]],
        }
        return dico

    def Trace(self, FORMAT='TABLEAU', **kargs):
        """Tracé d'une fonction"""
        gr = Graph()
        para = self.Parametres()
        gr.AjoutCourbe(
            Val=self.Valeurs(),
            Lab=[para['NOM_PARA'], para['NOM_RESU']],
            Leg=os.linesep.join(self.sdj.TITR.get() or []))
        gr.Trace(FORMAT=FORMAT, **kargs)
