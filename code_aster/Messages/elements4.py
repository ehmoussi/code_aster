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

from ..Utilities import _

cata_msg = {

    1 : _("""
  erreur dans le calcul de PRES_F
"""),

    2 : _("""
 pour l'option INDIC_ENER, les seules relations admises sont "VMIS_ISOT_LINE" et "VMIS_ISOT_TRAC" .
"""),

    3 : _("""
 pour l'option INDIC_SEUIL, les seules relations admises sont "VMIS_ISOT_LINE", "VMIS_ISOT_TRAC"  et "VMIS_CINE_LINE" .
"""),
    4 : _("""
 L'option SIPM_ELNO n'est pas autorisée pour les sections de poutre de type GENERALE
 pour les éléments de poutre autres que multifibre.
 En effet, dans ce cas il est impossible de connaître les contraintes extrêmes dans la section.

 Conseil :

 Vous pouvez utiliser des poutres multifibres pour calculer cette option.
"""),
    14 : _("""
  Vous utilisez un élément de type multifibre <%(k1)s>.
  Il faut que sous COMPORTEMENT le mot clef RELATION='MULTIFIBRE'.
"""),

    32 : _("""
 vous utilisez le mot clé LIAISON_ELEM avec l'option COQ_POU: l'épaisseur des éléments de bord de coque n'a pas été affectée.
"""),

    33 : _("""
 l'épaisseur des éléments de bord de coque est négative ou nulle.
"""),

    34 : _("""
 le jacobien est nul.
"""),

    38 : _("""
 option  %(k1)s  non active pour un élément de type  %(k2)s
"""),

    39 : _("""
 option  %(k1)s  : incompatibilité des deux champs d entrée
"""),

    40 : _("""
 le nombre de ddl est trop grand
"""),

    41 : _("""
 le nombre de ddl est faux
"""),

    42 : _("""
 nom de type élément inattendu
"""),

    43 : _("""
 comportement. élastique inexistant
"""),

    44 : _("""
 l'option " %(k1)s " est interdite pour les tuyaux
"""),

    45 : _("""
 l'option " %(k1)s " en repère local est interdite pour les tuyaux : utiliser le repère global
"""),

    46 : _("""
 le nombre de couches et de secteurs doivent être supérieurs a 0
"""),

    48 : _("""
 champ  %(k1)s  non traité, on abandonne
"""),

    49 : _("""
 l'option " %(k1)s " est non prévue
"""),

    51 : _("""
  NUME_SECT incorrect
"""),

    53 : _("""
MODI_METRIQUE pas adapté
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    54 : _("""
MODI_METRIQUE pas adapté
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    56 : _("""
 famille inexistante  %(k1)s
"""),

    57 : _("""
Intégration normale ou intégration réduite obligatoirement.
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    58 : _("""
  le code " %(k1)s " est non prévu
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    59 : _("""
Pour l'option %(k1)s, vous ne pouvez affecter qu'un seul matériau qui ne doit avoir
qu'un seul comportement : ELAS. Commande DEFI_MATERIAU / ELAS.
Conseil :
   Définir un seul matériau avec un seul comportement : ELAS.
"""),

    61 : _("""
 préconditions non remplies
"""),

    62 : _("""
  erreur: élément non 2d
"""),

    63 : _("""
  l'option %(k1)s n'est pas disponible pour le comportement %(k2)s
"""),

    64 : _("""
Pour l'option %(k1)s votre matériau doit avoir un seul comportement : ELAS.
Commande DEFI_MATERIAU / ELAS.
Votre matériau a %(k2)s comme comportement possible.
Conseil :
   Définir un matériau avec un seul comportement : ELAS.
"""),

    65 : _("""
  Comportement inattendu : %(k1)s.
"""),

    67: _("""
Le module de Young est nul.
"""),

    69 : _("""
 Problème récupération donnée matériau dans THM_LIQU %(k1)s
"""),

    70 : _("""
 Problème récupération donnée matériau dans THM_INIT %(k1)s
"""),

    71 : _("""
 Problème récupération données matériau dans ELAS %(k1)s
"""),

    72 : _("""
On ne trouve pas le coefficient de Poisson
"""),

    73 : _("""
Les comportements écrits en configuration de référence ne sont pas disponibles
sur les éléments linéaires pour la modélisation 3D_SI.

Pour contourner le problème et passer à un comportement en configuration actuelle,
ajoutez un état initial nul au calcul.
"""),







    78 : _("""
 Problème récupération donnée matériau dans THM_DIFFU %(k1)s
"""),

    79 : _("""
 la loi de comportement n'existe pas pour la modélisation DKTG :  %(k1)s
"""),

    80 : _("""
  L'élément de plaque QUAD4 défini sur la maille : %(k1)s
  n'est pas plan et peut conduire a des résultats faux.

  Conseil : Si vous utilisez de l'excentrement, essayez de mailler
            en utilisant des triangles.
"""),

    81 : _("""
 Il manque le paramètre  %(k1)s pour la maille  %(k2)s
"""),

    82 : _("""
  Distance au plan :  %(r1)f
"""),

    84 : _("""
 famille non disponible élément de référence  %(k1)s
 famille  %(k2)s
"""),

    88 : _("""
élément de référence  %(k1)s non disponible
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    90 : _("""
 élément mal programmé maille  %(k1)s  type  %(k2)s  nombre noeuds  %(i1)d
 nombre noeuds pour le passage Gauss noeuds  %(i2)d
"""),

    91 : _("""
 Le calcul de cet estimateur ne tient pas compte d'éventuelles
 conditions limites non linéaires
"""),

    92 : _("""
 Vous essayez d'appliquer un chargement de pression fonction (et non nul) sur un élément de coque (avec le mot-clé facteur PRES_REP) pour la maille %(k1)s.

 Pour cette modélisation, il faut utiliser le mot-clé FORCE_COQUE.
"""),

    93 : _("""
 Vous essayez d'appliquer un chargement de pression suiveur (et non nul) sur un élément 'DKT' (avec le mot-clé facteur PRES_REP et le mot-clé TYPE_CHARGE='SUIV') pour la maille %(k1)s.
 Cette fonctionnalité n'est pas disponible.

 Conseil :
    - remplacez la modélisation 'DKT' par la modélisation 'COQUE_3D'.
"""),

}
