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
Erreur dans les données. Le paramètre %(k1)s n'existe pas dans la table.
"""),

    2 : _("""
Paramètre %(k1)s inexistant dans la table %(k2)s.
"""),

    3 : _("""
Opération RENOMME. Erreur : %(k1)s
"""),

    4 : ("""
NOM_PARA ne doit contenir qu'un seul nom de paramètres pour ajouter
une colonne non constante.
"""),

    5 : ("""
Seuls les paramètres de types réels ou entiers sont imprimés au format NUMPY.

Paramètres non supportés :
    %(k1)s
"""),

    6 : _("""
Le fichier %(k1)s existe déjà, on écrit à la suite.
"""),

    7 : _("""
Paramètre absent de la table : %(k1)s.
"""),

    8 : _("""
Paramètres absents de la table (ou de NOM_PARA) : %(k1)s.
"""),

    10 : _("""
NUME_TABLE=%(i1)d incorrect : il n'y a que %(i2)d blocs de tables dans le fichier.
"""),

    11 : _("""
Nombre de champs incorrect ligne %(i1)d.
"""),

    12 : _("""
On attend %(i1)d paramètres.
"""),

    13 : _("""
On attend %(i1)d champs dans le fichier.
"""),

    14 : ("""
Les listes %(k1)s et %(k2)s doivent avoir le même cardinal.
"""),

    15 : _("""
Le format de la ligne semble incorrect.
Ligne lue :
    %(k1)s

Il ne satisfait pas l'expression régulière :
    %(k2)s
"""),

    16 : ("""
Les variables dans au moins d'une colonne ne sont pas de type réel ou entier.
Les calculs demandés ne sont pas possibles.
"""),


    19 : _("""La formule dépend de %(i1)d paramètre(s).
Vous devez fournir autant de nom de colonne dans NOM_COLONNE."""),

    20 : _("""Erreur lors de la construction des n-uplets
"""),

    21 : _("""La table doit avoir exactement deux paramètres pour une impression au format XMGRACE.
"""),

    22 : _("""Les cellules ne doivent contenir que des nombres réels
"""),

    23 : _("""Le paramètre %(k1)s est en double.
"""),

    24 : _("""Le paramètre %(k1)s existe déjà.
"""),

    25 : _("""'%(k1)s' n'a pas d'attribut '%(k2)s'.
"""),

    27 : _("""Les paramètres n'existent pas dans la table : %(k1)s
"""),

    28 : _("""L'argument '%(k1)s' doit être de type '%(k2)s'.
"""),

    29 : _("""Valeur incorrecte pour ORDRE : %(k1)s
"""),

    30 : _("""Les paramètres doivent être les mêmes dans les deux tables pour
faire l'intersection  ou l'union (opérateurs &, |).
"""),

    31 : _("""Type du paramètre '%(k1)s' non défini.
"""),

    32 : _("""Type du paramètre '%(k1)s' forcé à '%(k2)s'.
"""),

    33 : _("""Erreur pour le paramètre '%(k1)s' :
   %(k2)s
"""),

    34 : _("""La colonne '%(k1)s' est vide.
"""),

    35 : _("""La table est vide !
"""),

    36 : _("""La table doit avoir exactement trois paramètres.
"""),

    37 : _("""
   La table %(k1)s n'existe pas dans le résultat %(k2)s.
"""),

    38 : _("""Champ %(k1)s inexistant à l'ordre %(i1)d .
"""),

    39 : _("""
Aucun numéro d'ordre associé à l'accès %(k1)s de valeur %(i1)d
Veuillez vérifier vos données.
"""),

    40 : _("""
Aucun numéro d'ordre associé à l'accès %(k1)s de valeur %(r1)f
Veuillez vérifier vos données.
"""),

    41 : _("""
Les mots-clés 'NOEUD' et 'GROUP_NO' ne sont pas autorisés pour
les champs élémentaires (ELNO/ELGA).
"""),

    42 : _("""
Développement non réalisé pour les champs dont les valeurs sont complexes.
"""),

    43 : _("""
Lecture des noms de paramètres.
On attend %(i1)d noms et on a lu cette ligne :

%(k1)s

Conseil : Vérifier que le séparateur est correct et le format du fichier
    à lire.
"""),

    44 : _("""
La table '%(k1)s' est composée de %(i1)d lignes x %(i2)d colonnes.

Son titre est :
%(k2)s
"""),

    45 : _("""
Erreur de type lors de la lecture de la table :

Exception : %(k1)s

Conseil :
    Cette erreur se produit quand on relit au FORMAT='TABLEAU' une table qui a été
    imprimée au FORMAT='ASTER' car la deuxième ligne contient des types et non des valeurs.
    Si c'est le cas, utilisez LIRE_TABLE au FORMAT='ASTER'.
"""),

    46 : _("""
Plusieurs numéros d'ordre sont associés à l'accès %(k1)s de valeur %(r1)f


Conseil :
    Vous pouvez modifier la recherche en renseignant le mot clé PRECISION.
"""),
}
