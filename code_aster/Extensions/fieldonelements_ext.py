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

# person_in_charge: mathieu.courtois@edf.fr

from libaster import FieldOnElementsDouble
from ..Utilities import deprecated, import_object


class injector(object):
    class __metaclass__(FieldOnElementsDouble.__class__):
        def __init__(self, name, bases, dict):
            for b in bases:
                if type(b) not in (self, type):
                    for k, v in dict.items():
                        setattr(b, k, v)
            return type.__init__(self, name, bases, dict)


class ExtendedFieldOnElementsDouble(injector, FieldOnElementsDouble):
   cata_sdj = "SD.sd_champ.sd_cham_elem_class"

   def EXTR_COMP(self,comp=' ',lgma=[],topo=0) :
      """ retourne les valeurs de la composante comp du champ sur la liste
        de groupes de mailles lgma avec eventuellement l'info de la
        topologie si topo>0. Si lgma est une liste vide, c'est equivalent
        a un TOUT='OUI' dans les commandes aster
        Attributs retourne
          - self.valeurs : numpy.array contenant les valeurs
        Si on a demande la topo  :
          - self.maille  : numero de mailles
          - self.point   : numero du point dans la maille
          - self.sous_point : numero du sous point dans la maille """
      import numpy
      import aster
      if not self.accessible() :
         raise Accas.AsException("Erreur dans cham_elem.EXTR_COMP en PAR_LOT='OUI'")

      ncham=self.get_name()
      ncham=ncham+(19-len(ncham))*' '
      nchams=aster.get_nom_concept_unique('_')
      ncmp=comp+(8-len(comp))*' '

      aster.prepcompcham(ncham,nchams,ncmp,"EL      ",topo,lgma)

      valeurs=numpy.array(aster.getvectjev(nchams+(19-len(nchams))*' '+'.V'))

      if (topo>0) :
         maille=(aster.getvectjev(nchams+(19-len(nchams))*' '+'.M'))
         point=(aster.getvectjev(nchams+(19-len(nchams))*' '+'.P'))
         sous_point=(aster.getvectjev(nchams+(19-len(nchams))*' '+'.SP'))
      else :
         maille=None
         point=None
         sous_point=None

      aster.prepcompcham("__DETR__",nchams,ncmp,"EL      ",topo,lgma)

      return post_comp_cham_el(valeurs,maille,point,sous_point)

# post-traitement :
class post_comp_cham_el :
    def __init__(self, valeurs, maille=None, point=None, sous_point=None) :
        self.valeurs = valeurs
        self.maille = maille
        self.point = point
        self.sous_point = sous_point
