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

     1 : _("""Liste des champs lus."""),

     2 : _("""Champ %(k1)s."""),

     3 : _("""Pour le numéro d'ordre %(i1)d, le paramètre d'accès de nom %(k1)s vaut %(r1)g."""),

    14 : _("""Le NUME_DDL a été déterminé à partir de la matrice de rigidité %(k1)s."""),

    15 : _("""Les NUME_DDL associés aux matrices MATR_RIGI et MATR_MASS sont différents."""),

    16 : _("""Vous essayez de stocker les chargements dans le résultat. Ce n'est pas possible pour un résultat de type %(k1)s, on ne stocke pas le chargement."""),

    17 : _("""Le modèle étant absent, on ne peut pas vérifier le comportement et la cohérence du nombre de variables internes.
 Il faut renseigner le mot-clé MODELE.
"""),

    18 : _("""Il n'est pas possible d'avoir plusieurs types de champ simultanément dans LIRE_RESU pour la structure de données des modes empiriques."""),

    24 : _("""Le champ %(k2)s est incompatible avec le type de résultat %(k1)s."""),

    94 : _("""Le champ %(k1)s n'est pas prévu dans LIRE_RESU. Vous pouvez demander l'évolution."""),

    95 : _("""Le champ %(k1)s n'est pas prévu dans LIRE_CHAMP. Vous pouvez demander l'évolution."""),

    97 : _("""On n'a pu lire aucun champ dans le fichier. La structure de données créée est vide.
Risques & Conseils :
  Si le fichier lu est au format IDEAS, et si la commande est LIRE_RESU,
  le problème vient peut-être d'une mauvaise utilisation (ou d'une absence d'utilisation)
  du mot clé FORMAT_IDEAS. Il faut examiner les "entêtes" des DATASET du fichier à lire.
"""),

}
