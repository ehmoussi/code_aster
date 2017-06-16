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

# person_in_charge: mickael.abbas at edf.fr

cata_msg = {

   1  : _(u"""Création des structures de données pour le post-traitement du calcul réduit."""), 

   2  : _(u"""Le modèle doit être le même sur les deux bases."""),

   3  : _(u"""Initialisations pour le post-traitement du calcul réduit."""), 

   4  : _(u"""On ne trouve pas la table des coordonnées réduites dans la structure de données résultat. Vérifiez qu'il vient bien d'un calcul réduit."""), 

   5  : _(u"""Création du résultat de nom %(k1)s sur le modèle complet de nom %(k2)s."""), 

   7  : _(u"""Le résultat sur le modèle complet sera de type %(k1)s."""),

   8  : _(u"""Le modèle est le même pour la reconstruction que le modèle réduit d'origine."""),

   9  : _(u"""Le modèle de la base %(k1)s n'est pas celui du modèle complet. Vérifiez que vous n'utilisez pas la base tronquée."""),

   10 : _(u"""Le résultat sur le modèle complet sera construit à partir du résultat réduit de nom %(k1)s sur le modèle %(k2)s."""),  

   11 : _(u"""Le résultat sur le modèle réduit contient %(i1)d numéros d'ordre."""), 

   12 : _(u"""La base empirique est construite sur le maillage %(k1)s alors que le modèle repose sur le maillage %(k2)s. Ce n'est pas possible."""), 

   13 : _(u"""Les deux modèles sont identiques, on ne peut rien tronquer !"""), 

   20 : _(u"""Reconstruction des champs sur tout le domaine."""),
 
   21 : _(u"""Reconstruction du champ primal."""),

   22 : _(u"""Reconstruction du champ dual."""),

   30 : _(u"""Construction de la matrice des modes. Dimensions: [%(i1)d,%(i2)d]."""),

}
