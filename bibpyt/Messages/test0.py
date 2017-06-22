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
    1 : _(u"""
Expression régulière invalide : %(k2)s

Exception retournée :
   %(k1)s
"""),

    2 : _(u"""
Le fichier n'a pas été fermé : %(k1)s
"""),

    3 : _(u"""
TEST_FICHIER impossible, fichier inexistant : %(k1)s
"""),

    4 : _(u"""
  Nom du fichier   : %(k1)s

                         Calculé                            Référence
"""),

    5 : _(u"""
TEST_FICHIER impossible:
    NB_VALE_I est obligatoire en présence de VALE_CALC_I.
"""),

    6 : {  'message' : _(u"""
Test strict activé.
TOLE_MACHINE est pris égal à %(r1)e quelle que soit la valeur renseignée pour le mot-clé.
"""),
           'flags': 'DECORATED',
           },

    7 : _(u"""
Le paramètre est de type '%(k1)s' alors que la valeur de référence est de type '%(k2)s'.
"""),

    8 : _(u"""
Valeur de TYPE_TEST non supportée : '%(k1)s'
"""),

    9 : _(u"""
Le champ '%(k1)s' est de type '%(k2)s' alors que la valeur de référence est de type '%(k3)s'.
"""),

    10 : _(u"""
Le champ '%(k1)s' est de type inconnu.
"""),

    11 : _(u"""
Le test n'a pas de sens quand la valeur de non régression (VALE_CALC) est nulle.

Il faut :
- soit fournir un ordre de grandeur pour faire la comparaison,
- soit faire un test avec une valeur de référence analytique ou autre
  (mots-clés REFERENCE et VALE_REFE).
"""),

    12 : _(u"""
Pour les tests de non régression de valeurs nulles, il faut définir un ordre de grandeur.
Dans le cas contraire, le test de non régression est ignoré.
"""),

    13 : _(u"""  Entiers :"""),

    14 : _(u"""  Réels :"""),

    15 : _(u"""  Nombre de valeurs : %(i1)-17d                       %(i2)-17d"""),

    16 : _(u"""  Somme des valeurs : %(i1)-17d                       %(i2)-17d"""),

    17 : _(u"""  Somme des valeurs : %(r1)17.10e                  %(r2)17.10e"""),

    18 : _(u"""  Somme de contrôle : %(k1)s  %(k2)s


"""),

    19 : {
        "message": _(u"""Attention: Il s'agit d'un test de validation, on ne vérifie
pas la non régression."""),
        "flags": "DECORATED",
        },

    20 : _(u"""  Le groupe de maille %(k1)s contient %(i1)d mailles, il en faut une au maximum """),


}
