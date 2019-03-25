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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    8 : _("""
 arrêt sur maillage non squelette
"""),

    10 : _("""
 problème de duplication de la matrice :  %(k1)s
"""),

    11 : _("""
  arrêt problème de factorisation
  présence de modes de corps rigide
"""),

    17 : _("""
 arrêt sur problème base modale sans INTERF_DYNA
 base modale -->  %(k1)s
"""),

    26 : _("""
 conflit de nom de groupe de maille dans le squelette
 le nom de groupe               :  %(k1)s
 provenant de la sous-structure :  %(k2)s
 et du groupe de maille         :  %(k3)s
 existe déjà.
 %(k4)s
"""),

    27 : _("""
 nom de groupe non trouvé
 le groupe :  %(k1)s n'existe pas  %(k2)s dans la sous-structure :  %(k3)s
"""),

    28 : _("""
 aucun axe de rotation défini
"""),

    35 : _("""
 numéro de mode de votre liste inexistant dans les modes utilisés:
 numéro dans votre liste : %(i1)d
"""),

    39 : _("""
 choc mal défini
 la maille définissant le choc  %(k1)s doit être de type  %(k2)s
"""),

    41 : _("""
 trop de noeuds dans le GROUP_NO  %(k1)s
 noeud utilisé:  %(k2)s
"""),

    44 : _("""
 Aucun des chargements présents ne correspond à une excitation de type MULT_APPUI.
 Aucune correction n'est alors apportée aux résultats, calculés en relatif.
"""),

    46 : _("""
 Il manque les modes statiques. Vérifiez que MODE_STAT est bien renseigné.
"""),

    47 : _("""
 Il manque les modes corrigés. Vérifiez que MODE_CORR est bien renseigné.
"""),

    48 : _("""
 Nombre de modes propres calcules insuffisant.
 Nombre de modes propres de la base limite à : %(i1)d
"""),

    49 : _("""
 sous-structure inexistante dans le modèle généralisé
 modèle généralisé       -->  %(k1)s
 sous-structure demandée -->  %(k2)s
"""),

    50 : _("""
 sous-structure inexistante dans le modèle généralisé
 modèle généralisé              -->  %(k1)s
 numéro sous-structure demandée -->  %(i1)d
"""),

    69 : _("""
Le noeud %(k1)s n'est pas du bon type
Ce message est un message d'erreur développeur.
Contactez le support technique.
    '
"""),

    75 : _("""
 détection d'une sous-structure non connectée
 sous-structure de nom: %(k1)s
"""),

    76 : _("""
 arrêt sur problème de connexion sous-structure
"""),

    78 : _("""
 les intervalles doivent être croissants
 valeur de la borne précédente :  %(i1)d
 valeur de la borne            :  %(i2)d
"""),

    79 : _("""
 l'intervalle entre les  deux derniers instants ne sera pas égal au pas courant :  %(i1)d
 pour l'intervalle  %(i2)d
"""),

    80 : _("""
 le nombre de pas est trop grand :  %(i1)d , pour l'intervalle  %(i2)d
"""),

    81 : _("""
 les valeurs doivent être croissantes
 valeur précédente :  %(i1)d
 valeur            :  %(i2)d
"""),

    82 : _("""
 la distance entre les deux derniers réels ne sera pas égale
 au pas courant :  %(r1)f,
 pour l'intervalle  %(i1)d
"""),

    99 : _("""
 matrice d'amortissement non créée dans le macro-élément :  %(k1)s
"""),

}
