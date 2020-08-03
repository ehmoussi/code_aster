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
    1: _("""
INST_FIN plus petit que INST_INIT.
"""),

    2: _("""
Le mot-clé MAILLE est interdit, utilisez GROUP_MA.
"""),

    3: _("""
Parmi les occurrences de CABLE_BP, le mot-clé ADHERENT renseigné dans DEFI_CABLE_BP
est 'OUI' pour certaines et 'NON' pour d'autres.
CALC_PRECONT ne peut pas traiter ce type de cas
"""),

    4: _("""
La liste d’instant fournie n’a pas permis d’identifier l’instant initial et
l’instant final de la mise en précontrainte.

Si vous avez renseigné l'opérande INST_INIT du mot-clé facteur INCREMENT, alors
cette valeur est prise en compte comme instant initial.
Si reuse est activé, l'instant initial est alors le dernier instant présent dans
l'objet résultat renseigné dans reuse.
Dans les autres cas, l'instant initial est le premier instant de la liste fournie.

Si vous avez renseigné l'opérande INST_FIN du mot-clé facteur INCREMENT, alors
cette valeur est prise en compte comme instant final. Sinon l'instant final
est la dernière valeur de la liste d'instants fournie.

"""),

    5: _("""
Pour que CALC_PRECONT puisse traiter correctement la mise en tension de câbles frottants
avec deux ancrages actifs, il est nécessaire de définir les noeuds d'ancrage à l'aide du mot-clé
GROUP_NO_ANCRAGE (et non NOEUD_ANCRAGE) dans DEFI_CABLE_BP.
"""),

    6: _("""La déformation %(k1)s n'est pas disponible pour l'élément CABLE_GAINE"""),

    8 : _("""
Problème de lecture de la table donnant la tension dans le câble (MODI_CABLE_ETCC ou MODI_CABLE_RUPT).
"""),
    
    9 : _("""
La table fournie dans DEFI_CABLE doit contenir l'abscisse curviligne et la tension du câble.
"""),

    10 : _("""
La table fournie n'a pas la bonne dimension : vérifiez qu'il s'agit du bon câble ou que plusieurs
instants ne sont pas contenus dans la table.
"""),

    11 : _("""
Les abscisses curvilignes de la table fournie ne correspondent pas à celles du câble étudié
"""),
    
    12 : _(""" Attention, vous voulez calculer les pertes par relaxation de l'acier, mais
      le coefficient RELAX_1000 est nul. Les pertes associées sont donc nulles.
"""),    
 
    13: _("""
Cas ADHERENT = 'NON' :
Attention le profil de tension calculé dans DEFI_CABLE_BP ne sera pas utilisé si vous poursuivez le calcul avec CALC_PRECONT.
Les paramètres des lois BPEL_**** ou ETCC_**** ne sont donc pas pris en compte lors de la mise en tension.
Les coefficients de frottement considérés sont ceux de la loi CABLE_GAINE_FROT.
"""),
    
    14 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande <NOEUD_ANCRAGE> : il faut définir 2 noeuds d'ancrage
"""),

    15 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande <GROUP_NO_ANCRAGE> : il faut définir 2 GROUP_NO d'ancrage
"""),

    16  : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande <NOEUD_ANCRAGE> : les 2 noeuds d'ancrage doivent être distincts
"""),

    17 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande <GROUP_NO_ANCRAGE> : les 2 GROUP_NO d'ancrage doivent être distincts
"""),

    18 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande type ancrage : les 2 extrémités sont passives -> armature passive
"""),

    19 : _("""
 mot-clé <DEFI_CABLE>, occurrence no  %(k1)s , opérande type ancrage : les 2 extrémités sont passives et la tension que vous voulez imposer est non nulle. C'est impossible 
"""),

    20 : _("""
 La carte des caractéristiques matérielles des éléments n existe pas. il faut préalablement affecter ces caractéristiques en utilisant la commande <AFFE_MATERIAU>
"""),
    
    21 : _("""
 la carte des caractéristiques géométriques des éléments de barre de section générale n existe pas. il faut préalablement affecter ces caractéristiques en utilisant la commande <AFFE_CARA_ELEM>
"""),

    22 : _("""
 mot-clé <DEFI_CABLE>, aucune câble ne semble défini : vérifier la table fournie
"""), 

    23 : _("""
 mot-clé <DEFI_CABLE>, la table fournie dans TABL_CABLE n'est pas correcte : vérifier la présence des 3 colonnes :  GROUP_MA, GROUP_NO1 et GROUP_NO2
"""),  

   24 : _("""
 mot-clé <DEFI_CABLE>, la table fournie dans TABL_CABLE contient %(k1)s câbles
"""),

    25: _("""
Erreur de mise en donnée
"""),
}
