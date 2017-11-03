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

    1 : _(u"""Gestion manuelle de la liste d'instants."""),

    2 : _(u"""Gestion automatique de la liste d'instants."""),

    3 : _(u"""Paramètres de la gestion automatique de la liste d'instants.
Pas minimum: %(r1)13.6G
Pas maximum: %(r2)13.6G
Nombre de pas maximum: %(i1)d
"""),

    4 : _(u"""La liste d'instants contient %(i1)d pas de temps et le pas de temps minimum vaut %(r1)13.6G."""),

    5 : _(u"""Il y a %(i1)d événements."""),

    6 : _(u"""Il y a %(i1)d schémas d'adaptations du pas de temps."""),

   10 : _(u"""L'événement %(i1)d est pour capturer les erreurs."""),

   11 : _(u"""L'événement %(i1)d est pour détecter la variation d'une grandeur."""),

   12 : _(u"""L'événement %(i1)d est pour détecter une collision."""),

   13 : _(u"""L'événement %(i1)d est pour capturer une interpénétration."""),

   14 : _(u"""L'événement %(i1)d est pour capturer la divergence du résidu."""),

   15 : _(u"""L'événement %(i1)d est pour détecter une instabilité."""),

   16 : _(u"""L'événement %(i1)d est pour détecter quand le résidu dépasse une valeur donnée."""),

   21 : _(u"""Avec ce critère pour la variation d'une grandeur: ( Champ: %(k1)s , Composante: %(k2)s ) %(k3)s %(r1)13.6G ."""),

   22 : _(u"""La pénétration maximale est de %(r1)13.6G ."""),

   23 : _(u"""La valeur maximale du résidu est de %(r1)13.6G ."""),

   30 : _(u"""Si cet événement se déclenche, on arrête le calcul."""),

   31 : _(u"""Si cet événement se déclenche, on découpe le pas de temps."""),

   32 : _(u"""Si cet événement se déclenche, on fait quelques itérations de Newton supplémentaires."""),

   33 : _(u"""Si cet événement se déclenche, on choisit l'autre solution issue de l'équation de pilotage mais quand on aura essayé les deux solutions, on ne découpera pas le pas de temps."""),

   34 : _(u"""Si cet événement se déclenche, on choisit l'autre solution issue de l'équation de pilotage et quand on aura essayé les deux solutions, on pourra découper le pas de temps."""),

   35 : _(u"""Si cet événement se déclenche, on adapte le coefficient de pénalisation."""),

   36 : _(u"""Si cet événement se déclenche, on continue le calcul."""),

   41 : _(u"""On peut augmenter au maximum de %(r1).2f %% le nombre d'itérations mais quand ce maximum sera atteint, on ne découpera pas le pas de temps."""),

   42 : _(u"""On peut augmenter au maximum de %(r1).2f %% le nombre d'itérations et quand ce maximum sera atteint, on pourra découper le pas de temps."""),

   45 : _(u"""On ne dépassera pas un coefficient de %(r1)13.6G."""),

   50 : _(u"""Le schéma d'adaptation %(i1)d du pas de temps ne se déclenche pas."""),

   51 : _(u"""Le schéma d'adaptation %(i1)d du pas de temps se déclenche à tous les instants."""),

   52 : _(u"""Le schéma d'adaptation %(i1)d du pas de temps se déclenche pour un seuil donné."""),

   60 : _(u"""La découpe du pas de temps est manuel."""),

   61 : _(u"""On découpe le pas de temps en %(i1)d incréments jusqu'à ce que le pas atteigne %(r1)13.6G."""),

   62 : _(u"""On découpe le pas de temps en %(i1)d incréments jusqu'à ce que le niveau atteigne %(i2)d."""),

   63 : _(u"""Le seuil est franchi quand, %(i1)d fois de suite, on fait exactement ou moins de %(i2)d itérations de Newton."""),

   64 : _(u"""Le seuil est franchi quand, %(i1)d fois de suite, on fait strictement moins de %(i2)d itérations de Newton."""),

   65 : _(u"""Le seuil est franchi quand, %(i1)d fois de suite, on fait exactement ou plus de %(i2)d itérations de Newton."""),

   66 : _(u"""Le seuil est franchi quand, %(i1)d fois de suite, on fait strictement plus de %(i2)d itérations de Newton."""),

   70 : _(u"""La découpe du pas de temps est automatique et utilise la méthode d'extrapolation à partir du résidu."""),

   71 : _(u"""La découpe du pas de temps est automatique et utilise la méthode d'estimation pour la gestion de la collision."""),

   72 : _(u"""La gestion du pas de temps après collision se fait à l'instant %(r1)13.6G et pour une durée de %(r2)13.6G ."""),

   80 : _(u"""Le mode de calcul de l'instant suivant est fixe."""),

   81 : _(u"""Le mode de calcul de l'instant suivant utilise la variation d'une grandeur."""),

   82 : _(u"""Le mode de calcul de l'instant suivant utilise la variation du  nombre d'itérations de Newton."""),

   83 : _(u"""Le mode de calcul de l'instant suivant utilise un schéma spécifique pour IMPLEX."""),

   84 : _(u"""Le pas de temps suivant sera modifié de %(r1).2f %%."""),

   85 : _(u"""Le pas de temps suivant sera modifié à l'aide d'un coefficient NB_ITER_NEWTON_REF dont la référence est %(i1)d."""),
}
