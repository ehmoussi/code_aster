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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    1: _(u"""
 Il y a moins de sous-domaines (%(i1)d) que de processeurs participant au calcul (%(i2)d).

 Conseils :
   - augmentez le nombre de sous-domaines de la partition du mot-clé DISTRIBUTION
   - diminuez le nombre de processeurs du calcul
"""),

    2: _(u"""
 Le partitionnement des mailles du maillage conduit à un sous-domaine ayant 0 maille.
 Le code ne sait pas traiter ce cas de figure.
 Conseils :
   - diminuez le nombre de processeurs du calcul.
   - diminuez le nombre de sous-domaines de la partition du mot-clé DISTRIBUTION
   - n'utilisez pas le parallélisme (trop peu d'éléments).
 
"""),

    17 : _(u"""
  La partition %(k1)s que vous utilisez pour partitionner le modèle %(k2)s en sous-domaines a été construite sur un autre modèle (%(k3)s).

  Conseil : vérifiez la cohérence des modèles.
"""),




    93 : _(u"""
 Il y a moins de mailles (%(i1)d) dans le modèle que de processeurs participant au calcul (%(i2)d).

 Conseils :
   - vérifiez qu'un calcul parallèle est approprié pour votre modèle
   - diminuez le nombre de processeurs du calcul
"""),


    98: _(u"""
  La maille de numéro:  %(i1)d appartient à plusieurs sous-domaines !
"""),

    99 : _(u"""
 Le paramètre CHARGE_PROC0_SD du mot-clé facteur DISTRIBUTION est mal renseigné.
 Il faut qu'il reste au moins un sous domaine par processeur une fois affectés tous les sous-domaines du processeur 0.

 Conseils :
   - laissez le mot-clé CHARGE_PROC0_SD à sa valeur par défaut
   - diminuez le nombre de processeurs du calcul ou bien augmentez le nombre de sous-domaines de la partition du mot-clé DISTRIBUTION
"""),

}
