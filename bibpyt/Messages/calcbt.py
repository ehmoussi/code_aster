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

# person_in_charge: marina.bottoni at edf.fr

cata_msg = {

    3: _("""
CALC_BT : Le paramètre RESI_RELA_TOPO doit impérativement être inférieur au paramètre RESI_RELA_SECTION. 
"""),

    4: _("""
CALC_BT : Le paramètre RESI_RELA_TOPO n'est pas utilisé avec l'option SECTION.
"""),

    5: _("""
 CALC_BT : Un des contours (extérieur ou intérieurs) fournis en entrée n'est pas fermé.
"""),
    
    6: _("""
CALC_BT : La structure treillis n'as pas pu être générée. Une réduction dans la valeur CRIT_ELIM est conseillée. 
"""),
    
    7: _("""
CALC_BT : La méthode d'optimisation n'a pas convergé. Pensez à augmenter NMAX_ITER. 
"""),

    8: _("""
CALC_BT : Le paramètre CRIT_ELIM n'est pas utilisé avec l'option SECTION.
"""),  

    9: _("""
CALC_BT : Seules les modélisations D_PLAN et C_PLAN sont acceptées. 
"""),
    
   10: _("""
CALC_BT : La structure treillis n'a pas pu être générée. Une augmentation dans la valeur LONGUEUR_MAX est conseillée. 
"""),

  
}
