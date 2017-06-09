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
  Erreur dans les données
  le paramètre %(k1)s n'existe pas dans la table %(k2)s
"""),

    2: _(u"""
  Erreur dans les données
  pas de tri sur les complexes
  paramètre:  %(k1)s
"""),

    3: _(u"""
  Erreur dans les données
  on n'a pas trouvé de ligne dans la table %(k1)s pour le paramètre %(k2)s
"""),

    4: _(u"""
  Le numéro d'occurrence est invalide %(i1)d pour le mot clé facteur %(k1)s
"""),

    5: _(u"""
  Le numéro de la composante (pour VARI_R) est trop grand.
    MAILLE           : %(k1)s
    NUME_MAXI        : %(i1)d
    NUME_CMP demandé : %(i2)d
"""),


    9: _(u"""
 Si on utilise l'option normale pour les changements de repère, il faut donner
 une équation supplémentaire avec le mot-clé VECT_X ou VECT_Y
 """),

    11: _(u"""
  Erreur dans les données, problème lors du traitement du mot clé facteur FILTRE

  -> Risque & Conseil :
   soit le paramètre n'existe pas
   soit aucune ligne ne correspond au paramètre donné
"""),

    12: _(u"""
  Erreur utilisateur dans la commande POST_ELEM/INTEGRALE :
    Pour le champ %(k1)s,
    Sur les mailles sélectionnées %(k2)s,
    On n'a pas trouvé la composante %(k3)s

  Risque & Conseil:
    Veuillez vérifier que le champ est défini sur les mailles du groupe spécifié et
    que les composantes du champ disposent de valeurs. Vous pouvez effectuer un
    IMPR_RESU pour imprimer les valeurs du champ %(k1)s sur les mailles sélectionnées.
"""),

    13: _(u"""
  Erreur utilisateur dans la commande POST_ELEM/INTEGRALE :
    Le champ %(k1)s est un CHAM_ELEM ELEM,
    Il faut renseigner le mot clé INTEGRALE / DEJA_INTEGRE= 'OUI' / 'NON'
"""),

    14 : _(u"""
  POST_ELEM VOLUMOGRAMME
  Numéro d'occurrence du mot-clé VOLUMOGRAMME = %(i1)d
  Numéro d'ordre                             = %(i2)d
  Volume total concerné                      = %(r1)g
"""),

}
