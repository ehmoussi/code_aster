# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
:py:class:`GeneralizedAssemblyVectorOnMesh` --- Assignment of material properties on mesh
************************************************************************
"""

import aster
from libaster import GeneralizedAssemblyVectorComplex, GeneralizedAssemblyVectorDouble

from ..Utilities import injector


class ExtendedGeneralizedAssemblyVectorComplex(injector(GeneralizedAssemblyVectorComplex),
                                               GeneralizedAssemblyVectorComplex):
    cata_sdj = "SD.sd_cham_gene.sd_cham_gene"

    def EXTR_VECT_GENE_C(self):
        import numpy
        if not self.accessible():
            raise AsException("Erreur dans vect_asse_gene_c.EXTR_VECT_GENE en PAR_LOT='OUI'")
        valeur=numpy.array(self.sdj.VALE.get(), complex)

        return valeur

    def RECU_VECT_GENE_C(self,vecteur):
        if not self.accessible():
            raise AsException("Erreur dans vect_asse_gene_c.RECU_VECT_GENE en PAR_LOT='OUI'")
        import numpy
        numpy.asarray(vecteur)
        ncham=self.get_name()
        ncham=ncham+(8-len(ncham))*' '
        desc = self.sdj.DESC.get()
        # On teste si le DESC de la matrice existe
        if not desc:
            raise AsException("L'objet vecteur {0!r} n'existe pas"
                              .format(self.sdj.DESC.nomj()))
        desc = numpy.array(desc)
        # On teste si la taille de la matrice jeveux et python est identique
        if desc[1] != numpy.shape(vecteur)[0] :
            raise AsException("La taille du vecteur python est incorrecte")
        tmpr=vecteur.real
        tmpc=vecteur.imag
        aster.putvectjev(ncham+(19-len(ncham))*' '+'.VALE',
                         len(tmpr),
                         tuple(range(1, len(tmpr)+1)),
                         tuple(tmpr),
                         tuple(tmpc),
                         1)
        return

class ExtendedGeneralizedAssemblyVectorDouble(injector(GeneralizedAssemblyVectorDouble),
                                              GeneralizedAssemblyVectorDouble):
    cata_sdj = "SD.sd_cham_gene.sd_cham_gene"

    def EXTR_VECT_GENE_R(self) :
      """ retourne les valeurs du vecteur generalisee
      dans un format numpy
         Attributs retourne
            - self.valeurs : numpy.array contenant les valeurs """
      import numpy
      if not self.accessible():
         raise AsException("Erreur dans vect_asse_gene_r.EXTR_VECT_GENE en PAR_LOT='OUI'")
      valeur = numpy.array(self.sdj.VALE.get())
      return valeur

    def EXTR_VECT_GENE_C(self):
        import numpy
        if not self.accessible():
            raise AsException("Erreur dans vect_asse_gene_c.EXTR_VECT_GENE en PAR_LOT='OUI'")
        valeur=numpy.array(self.sdj.VALE.get(), complex)

        return valeur

    def RECU_VECT_GENE_C(self,vecteur):
        if not self.accessible():
            raise AsException("Erreur dans vect_asse_gene_c.RECU_VECT_GENE en PAR_LOT='OUI'")
        import numpy
        numpy.asarray(vecteur)
        ncham=self.get_name()
        ncham=ncham+(8-len(ncham))*' '
        desc = self.sdj.DESC.get()
        # On teste si le DESC de la matrice existe
        if not desc:
            raise AsException("L'objet vecteur {0!r} n'existe pas"
                              .format(self.sdj.DESC.nomj()))
        desc = numpy.array(desc)
        # On teste si la taille de la matrice jeveux et python est identique
        if desc[1] != numpy.shape(vecteur)[0] :
            raise AsException("La taille du vecteur python est incorrecte")
        tmpr=vecteur.real
        tmpc=vecteur.imag
        aster.putvectjev(ncham+(19-len(ncham))*' '+'.VALE',
                         len(tmpr),
                         tuple(range(1, len(tmpr)+1)),
                         tuple(tmpr),
                         tuple(tmpc),
                         1)
        return
