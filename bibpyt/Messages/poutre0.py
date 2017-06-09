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
Problème lors de l'utilisation de MACR_CARA_POUTRE

GROUP_MA et GROUP_MA_BORD doivent avoir le même nombre de groupes de mailles.
À un GROUP_MA doit correspondre un GROUP_MA_BORD.
"""),

    2: _(u"""
Problème lors de l'utilisation de MACR_CARA_POUTRE

Vous avez renseigné NOEUD avec GROUP_MA et GROUP_MA_BORD.
Le nombre de noeud doit être égal au nombre de groupes mailles donné à GROUP_MA et
GROUP_MA_BORD.
À un NOEUD doit correspondre un GROUP_MA et un GROUP_MA_BORD .
"""),

    3: _(u"""
Problème lors de l'utilisation de MACR_CARA_POUTRE

Vous avez renseigné NOEUD ou GROUP_NO avec GROUP_MA_BORD.
Il faut que NOEUD ou GROUP_NO contienne un noeud unique.

Si vous avez des groupes de mailles disjoints, il faut également renseigner GROUP_MA.
Et dans ce cas à un NOEUD doit correspondre un GROUP_MA et un GROUP_MA_BORD.
"""),

    4: _(u"""
Poutre circulaire à variation de section homothétique.

Le rapport d'homothétie est assez différent entre les rayons et les épaisseurs :
    - rayon 1 = %(r1)16.9g
    - rayon 2 = %(r2)16.9g
        `- rapport d'homothétie = %(r5)16.9g

    - épaisseur 1 = %(r3)16.9g
    - épaisseur 2 = %(r4)16.9g
        `- rapport d'homothétie = %(r6)16.9g

La différence entre les rapports d'homothétie est supérieure à 1%%.
Les hypothèses du modèle de poutre à variation homothétique ne sont donc pas
respectées (consultez la documentation de référence des éléments poutre).


Risques et conseil:
    - Les calculs seront inexacts.
    - Raffiner le maillage permet de minimiser les écarts.
"""),


    5: _(u"""
Problème lors de l'utilisation de MACR_CARA_POUTRE

Vous avez renseigné GROUP_NO avec GROUP_MA et GROUP_MA_BORD.
Le nombre de noeud dans GROUP_NO doit être identique au nombre de groupe de mailles
donné sous GROUP_MA et GROUP_MA_BORD.
"""),


    6: _(u"""
Problème lors de l'utilisation de MACR_CARA_POUTRE

Vous avez renseigné GROUP_MA et GROUP_MA_BORD avec plusieurs groupes de mailles.
Vous devez renseigner 'LONGUEUR' 'MATERIAU' 'LIAISON', pour que l'on puisse calculer les
caractéristiques de torsion en prenant en compte les facteurs de participation de chaque
groupe de mailles.
"""),


    7: _(u"""
Vous avez renseigné GROUP_MA et GROUP_MA_BORD avec un seul groupe de mailles par
mot clef.
Vous avez également renseigné 'LONGUEUR' 'MATERIAU' 'LIAISON', cela est inutile.
Les valeurs sont ignorées.
"""),


    8: _(u"""
Problème lors de l'utilisation de MACR_CARA_POUTRE

Vous avez renseigné GROUP_NO. Le GROUP_NO %(k1)s n'existe pas dans le maillage.
"""),


    9: _(u"""
Problème lors de l'utilisation de MACR_CARA_POUTRE

Vous avez renseigné NOEUD. Le noeud %(k1)s n'existe pas dans le maillage.
"""),


   10: _(u"""La caractéristique %(k1)8s est négative ou nulle %(r1)e
"""),


   11: _(u"""
Problème lors de l'utilisation de MACR_CARA_POUTRE

La section présente des caractéristiques mécaniques négatives.

Vous avez renseigné l'option TABLE_CARA='OUI'. Si vous utilisez les résultats dans la commande
AFFE_CARA_ELEM / POUTRE avec TABLE_CARA, vous risquez d'avoir des résultats faux.

Conseil : La discrétisation de la section a un impact sur la qualité des résultats.
          Raffiner le maillage devrait permettre de lever cette erreur.
"""),


   12: _(u"""
Les coordonnées du centre de gravité de la section sont G=(%(r1)e, %(r2)e)

Si vous utilisez des MULTIFIBRES et que le maillage de description des fibres est le même que
celui utilisé dans cette commande, il faut dans la commande DEFI_GEOM_FIBRE renseigner le mot
clef COOR_AXE_POUTRE de façon à faire correspondre le centre de gravité des fibres à l'axe
neutre de la poutre : COOR_AXE_POUTRE = (%(r1)e, %(r2)e)

Vous avez renseigné l'option TABLE_CARA='OUI'. Si vous utilisez les résultats dans la commande :
   AFFE_CARA_ELEM / POUTRE avec TABLE_CARA,
                  / GEOM_FIBRE
                  / MULTIFIBRE
Vous risquez d'avoir des résultats inattendus, si vous ne renseignez pas COOR_AXE_POUTRE.
"""),


   13: _(u"""
Le repère principal d'inertie est tourné d'un angle de %(r1)f° par rapport aux axes du maillage.

Si vous utilisez des MULTIFIBRES et que le maillage de description des fibres est le même que
celui utilisé dans cette commande, il faut dans la commande DEFI_GEOM_FIBRE renseigner le mot
clef ANGLE de façon à faire correspondre le repère principal d'inertie aux axes du maillage de
la section : ANGLE = %(r2)e

Vous avez renseigné l'option TABLE_CARA='OUI'. Si vous utilisez les résultats dans la commande
AFFE_CARA_ELEM / POUTRE avec TABLE_CARA, il est peut-être nécessaire dans la commande
AFFE_CARA_ELEM de renseigner le mot clef ORIENTATION de façon à définir la position du repère
principal d'inertie par rapport au repère global.

ORIENTATION=(
    _F(GROUP_MA='....', CARA='ANGL_VRIL', VALE= ??? )
)
Par défaut ANGL_VRIL= 0

Vous risquez d'avoir des résultats inattendus, si vous ne renseignez ni :
 - ANGLE dans DEFI_GEOM_FIBRE
 - ORIENTATION dans AFFE_CARA_ELEM
"""),


   20: _(u"""
Problème lors de l'utilisation de MACR_CARA_POUTRE

Vous avez renseigné %(k2)s. Le GROUP_MA %(k1)s n'existe pas dans le maillage.
"""),



}
