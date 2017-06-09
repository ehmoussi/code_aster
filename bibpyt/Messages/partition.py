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




    2: _(u"""
Le modèle ne contient aucun élément fini. On ne peut pas le partitionner.

Conseil : il faut utiliser DISTRIBUTION / METHODE='CENTRALISE'
"""),

    3: _(u"""
Le modèle contient des noeuds (AFFE_MODELE/AFFE/GROUP_NO). On ne peut pas le partitionner.

Conseil : il faut créer des mailles POI1 avec l'opérateur CREA_MAILLAGE/CREA_POI1
          puis refaire un MODELE avec AFFE_MODELE/AFFE/GROUP_MA uniquement.
"""),

    4: _(u"""
Le modèle contient des mailles qui n'ont aucun lien entre eux.

Conseil :  il faut utiliser DISTRIBUTION / METHODE='CENTRALISE'.
"""),

}
