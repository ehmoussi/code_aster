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

    1 : _("""Les poutres ne sont pas utilisables dans la commande REST_COND_TRAN."""),

    2 : _("""Vous n'avez pas renseigné NOM_CHAM dans REST_COND_TRAN."""),

    3 : _("""On a rencontré un problème lors de la lecture de la discrétisation (instants ou fréquences )."""),

    4 : _("""La SD EVOL_NOLI utilisée dans REST_COND_TRAN ne contient pas les champs généralisés.
Vérifiez qu'il s'agit du même concept que celui utilisé dans le DYNA_NON_LINE,
option PROJ_MODAL et que l'archivage a été fait (mot-clef ARCHIVAGE de DYNA_NON_LINE)."""),
}
