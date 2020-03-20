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

cata_msg = {

    1  : _("""On ne sait pas imprimer le champ de type %(k1)s dans ce format."""),

    2  : _("""On ne sait pas imprimer le champ de type %(k1)s dans ce format. Veuillez utiliser IMPR_GENE pour l'impression
 de résultats en variables généralisées."""),

    3  : _("""On ne sait pas imprimer les champs de type carte dans ce format."""),

    4  : _("""Le champ de type %(k1)s et de numéro d'ordre %(i1)d n'existe pas. Il ne sera donc pas imprimé."""),

    5  : _("""La composante %(k1)s n'existe dans aucun des champs du résultat."""),

    6  : _("""On ne trouve pas le noeud %(k1)s dans le maillage, la sélection sera ignorée."""),

    7  : _("""On ne trouve pas le groupe de noeuds %(k1)s dans le maillage, la sélection sera ignorée."""),

    8  : _("""Le groupe de noeuds %(k1)s ne contient aucun noeud, la sélection sera ignorée."""),

    9  : _("""On ne trouve pas l'élément %(k1)s dans le maillage, la sélection sera ignorée."""),

    10 : _("""On ne trouve pas le groupe d'éléments %(k1)s dans le maillage, la sélection sera ignorée."""),

    11 : _("""Le groupe d'éléments %(k1)s ne contient aucun élément, la sélection sera ignorée."""),

    12 : _(""" Le fichier correspondant à l'unité logique renseignée pour l'écriture de résultats au format MED est de type ASCII. 
Cela peut engendrer l'affichage de messages intempestifs provenant de la bibliothèque MED. Il n'y a toutefois aucun risque de résultats faux.
Pour supprimer l'émission de ce message d'alarme, il faut donner la valeur BINARY au  mot-clé TYPE de DEFI_FICHIER."""),

    13 : _("""La variable interne %(k1)s n'existe pas sur l'élément. On ne l'imprime pas."""),

    25 : _("""On ne trouve pas la composante %(k1)s dans la grandeur %(k2)s."""),

    34 : _("""On ne sait pas écrire les champs aux noeuds de représentation constante et à valeurs complexes au format RESULTAT."""),

    35 : _("""On ne sait pas écrire les champs aux noeuds de représentation constante et à valeurs complexes dans ce format."""),

    40 : _("""Aucune des composantes demandées sous le mot-clé NOM_CMP pour l'impression du champ %(k1)s n'est présente."""),

    46 : _("""Le numéro d'ordre %(i1)d n'est pas licite. On n'imprime pas le champ."""),

    63 : _("""Le mot clé INFO_MAILLAGE est réservé au format MED."""),

    65 : _("""Pour la variable d'accès NOEUD_CMP, il faut un nombre pair de valeurs."""),

    66 : _("""Le modèle et le maillage introduits ne sont pas cohérents."""),

    68 : _("""Le format GMSH ne permet pas d'imprimer simultanément un maillage et un champ (ou un résultat)."""),

    69 : _(""" L'impression d'un champ complexe nécessite l'utilisation du mot-clé PARTIE. Ce mot-clé permet de choisir la partie du champ à imprimer (réelle ou imaginaire)."""),

    70 : _(""" Vous avez demandé une impression au format ASTER sans préciser de MAILLAGE. Aucune impression ne sera réalisée car IMPR_RESU au format ASTER n'imprime qu'un MAILLAGE."""),

    74 : _("""Le maillage fourni n'est pas cohérent avec le maillage qui porte le résultat."""),

    97: _("""Le champ %(k1)s a des éléments ayant des sous-points. Ils seront supprimés à l'impression."""),

    98 : _("""Le champ %(k1)s a des éléments ayant des sous-points. Il est écrit avec un format différent du format RESULTAT."""),

    99 : _("""Le champ %(k1)s utilise une grandeur physique qui n'est ni un réel, ni un complexe. Il est écrit avec un format différent du format RESULTAT."""),
}
