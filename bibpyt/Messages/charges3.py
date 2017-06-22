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
  Le concept EVOL_CHAR %(k1)s ne contient aucun champ.
"""),

    2 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s.
L'extraction du chargement volumique 3D a échoué pour l'instant %(r1)f.
Le chargement est mal défini:
- soit %(k1)s n'est pas indexé par l'instant;
- soit le chargement n'a pas été trouvé pour cet instant;
"""),

    3 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s.
L'extraction du chargement volumique 2D a échoué pour l'instant %(r1)f.
Le chargement est mal défini:
- soit %(k1)s n'est pas indexé par l'instant;
- soit le chargement n'a pas été trouvé pour cet instant;
"""),


    4 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s pour l'instant %(r1)f.
Il y a simultanément un chargement de type volumique 2D et un chargement de type surfacique 3D.
"""),

    5 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s.
L'extraction du chargement surfacique 3D a échoué pour l'instant %(r1)f.
Le chargement est mal défini:
- soit %(k1)s n'est pas indexé par l'instant;
- soit le chargement n'a pas été trouvé pour cet instant;
"""),

    6 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s pour l'instant %(r1)f.
Il y a simultanément un chargement de type volumique 3D et un chargement de type surfacique 2D.
"""),

    7 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s.
L'extraction du chargement surfacique 2D a échoué pour l'instant %(r1)f.
Le chargement est mal défini:
- soit %(k1)s n'est pas indexé par l'instant;
- soit le chargement n'a pas été trouvé pour cet instant;
"""),

    8 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s.
L'extraction du chargement de pression a échoué pour l'instant %(r1)f.
Le chargement est mal défini:
- soit %(k1)s n'est pas indexé par l'instant;
- soit le chargement n'a pas été trouvé pour cet instant;
"""),

    9 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s.
L'interpolation de la vitesse a échoué pour l'instant %(r1)f.
Le chargement est mal défini:
- soit %(k1)s n'est pas indexé par l'instant;
- soit le chargement n'a pas été trouvé pour cet instant;
"""),

    10: _(u"""
Les composantes dans le champ de vent %(k1)s doivent être exactement DX, DY et DZ.
"""),

    12 : _(u"""
Problème lors du traitement du chargement de type EVOL_CHAR %(k1)s.
L'extraction du chargement a échoué pour l'instant %(r1)f.
Le chargement est mal défini:
- soit %(k1)s n'est pas indexé par l'instant;
- soit le chargement n'a pas été trouvé pour cet instant;
- soit il manque l'un des deux champs nécessaires;
"""),

}
