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

from . import *
from .sd_cham_no import sd_cham_no


class sd_fond_fissure(AsBase):
    nomj = SDNom(fin=8)
#   Vecteur (K8) contenant la liste des mailles de la lèvre inférieure de la fissure.
    LEVREINF_MAIL = Facultatif(AsVK8(SDNom(nomj='.LEVREINF.MAIL'), ))
#   Vecteur de trois rééls contenant les composantes de la normale au plan des lèvres d'une fissure plane.
    NORMALE = Facultatif(AsVR(lonmax=3, ))
#   Vecteur (K8) contenant la liste des N noeuds ordonnés du fond de fissure.
    FOND_NOEU = Facultatif(AsVK8(SDNom(nomj='.FOND.NOEU'), ))
#   Vecteur (K8) contenant la liste des noeuds de la lèvre inférieure sur la direction normale au fond de fissure.
    INFNORM_NOEU = Facultatif(AsVK8(SDNom(nomj='.INFNORM.NOEU'), ))
#   Vecteur (K8) contenant la liste des noeuds de la lèvre supérieure sur la direction normale au fond de fissure.
    SUPNORM_NOEU = Facultatif(AsVK8(SDNom(nomj='.SUPNORM.NOEU'), ))
#   Vecteur (K8) contenant la liste des mailles de la lèvre supérieure de la fissure.
    LEVRESUP_MAIL = Facultatif(AsVK8(SDNom(nomj='.LEVRESUP.MAIL'), ))
#   Vecteur (K8) contenant les informations sur la fissure.
    INFO = AsVK8(SDNom(nomj='.INFO'), lonmax=4, )
#   Vecteur de réels contenant pour chacun des noeuds du fond, une estimation de la taille suivant la direction radiale, des mailles qui leur sont connectées.
    FOND_TAILLE_R = Facultatif(AsVR(SDNom(nomj='.FOND.TAILLE_R'),))
#   Vecteur de réels contenant les abscisses curvilignes des noeuds du fond.
    ABSCUR = AsVR()
#   Champ aux noeuds scalaire qui contient pour chaque noeud du maillage la valeur réelle de la level set normale à la fissure.
    LNNO = Facultatif(sd_cham_no())
#   Champ aux noeuds scalaire qui contient pour chaque noeud du maillage la valeur réelle de la level set tangente à la fissure.
    LTNO = Facultatif(sd_cham_no())
#   Champ aux noeuds contenant les coordonnées des noeuds projetés sur le fond de fissure ainsi que les bases locales pour tous les noeuds du maillage.
    BASLOC = Facultatif(sd_cham_no())

    def check_BASLOC(self, checker):
        info = self.INFO.get_stripped()
        config = info[1]
        basloc = self.BASLOC.VALE.get()
        if config == 'DECOLLEE':
            assert basloc is None, config
        else:
            pass

