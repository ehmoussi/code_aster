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

from code_aster.Utilities import _

cata_msg = {

    1 : _("""
La variable d'environnement %(k1)s n'est pas définie.
"""),

    2 : _("""
Le chemin d'accès aux bibliothèques est trop long. Il doit être inférieur
à %(i1)d caractères. Il est défini par la variable d'environnement '%(k1)s'.

Conseil :
    Installer Code_Aster dans un chemin plus accessible, ou bien, créer
    un lien symbolique pour réduire la longueur du chemin.
"""),

}
