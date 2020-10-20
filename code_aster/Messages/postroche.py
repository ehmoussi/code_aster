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

    2 : _("""Le %(k1)s associé au résultat ou au champ de l'occurrence numéro %(i1)d de %(k2)s
est différent de celui associé au résultat ou au champ de la première occurrence ou de
celui renseigné dans la commande :

Modèle de référence     : %(k3)s
Modèle de l'occurrence %(i1)d : %(k4)s"""),

    3 : _("""Les données d'entrée ne sont associées à aucun concept %(k1)s.
Vous devez donc renseigner le mot-clé %(k1)s."""),

    4 : _("""On ne parvient pas à extraire le modèle de la première occurrence de
RESU_MECA ou de RESU_MECA_TRAN.

Conseils :
Renseignez le modèle via le mot-clé MODELE, ou changez l'ordre des occurrences afin que
le type de chargement SISM_INER_SPEC ne se trouve pas en première position."""),

    5 : _("""Vous avez renseigné le mot-clé facteur RESU_MECA_TRAN sans déclarer
d'occurrence de type SISM_INER_TRAN.
Si c'est un oubli, ajoutez-le, sinon utilisez RESU_MECA et non RESU_MECA_TRAN."""),

    6 : _("""Seule une occurrence de RESU_MECA_TRAN peut être de type SISM_INER_TRAN"""),
    
    7 : _("""Dans l'occurrence numéro %(i1)d de RESU_MECA_TRAN, les résultats donnés à
RESULTAT et à RESU_CORR n'ont pas les mêmes numéros d'ordre.

Vous pouvez utiliser NUME_ORDRE ou INST en indiquant seulement les instants communs.
"""),

    8 : _("""Attention, pour le numéro d'ordre %(i1)d il existe au moins un couple
maille/noeud pour lequel %(k1)s calculée est inférieure à la contrainte de pression déclarée.

On remplace cette valeur par la contrainte de pression.
"""),

    9 : _("""Attention, il existe au moins un couple maille/noeud pour lequel 
%(k1)s calculée est inférieure à la contrainte de pression déclarée.

On remplace cette valeur par la contrainte de pression.
"""),

   10 : _("""Des mailles ayant une autre modélisation que POU_D_T ont été
déclarées dans ZONE_ANALYSE.
"""),

   11 : _("""Traitement du pas de temps %(i1)d sur %(i2)d.
"""),

   12 : _("""Attention, pour le numéro d'ordre %(i1)d il existe au moins un couple
maille/noeud pour lequel %(k1)s calculée est supérieure à la contrainte de contrainte
de référence.
"""),

   13 : _("""Attention, il existe au moins un couple maille/noeud pour lequel 
%(k1)s calculée est supérieure à la contrainte de contrainte de référence.
"""),

   14 : _("""Attention, pour le numéro d'ordre %(i1)d il existe au moins un couple
maille/noeud pour lequel le nombre maximal d'itérations autorisées (%(i2)d) a été atteint sans
parvenir à vérifier le critère de convergence lors du calcul de %(k1)s .
"""),

   15 : _("""Attention, il existe au moins un couple
maille/noeud pour lequel le nombre maximal d'itérations autorisées (%(i1)d) a été atteint sans
parvenir à vérifier le critère de convergence lors du calcul de %(k1)s .
"""),

}
