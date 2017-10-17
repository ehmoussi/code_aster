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

# person_in_charge: sylvie.granet at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'HYDR_UTIL',
    doc            =   """Loi de comportement hydraulique, si le comportement mécanique est sans endommagement :
   Signifie qu'aucune donnée matériau n'est rentrée en dur.
   Concrètement dans le cas saturé, il faudra définir les 6 courbes point par point (par DEFI_FONCTION) suivantes :
   - la saturation en fonction de la pression capillaire,
   - la dérivée de cette courbe,
   - la perméabilité relative au liquide en fonction de la saturation,
   - sa dérivée.
   - la perméabilité relative au gaz en fonction de la saturation,
   - sa dérivée."""          ,
    num_lc         = 0,
    nb_vari        = 1,
    nom_vari       = ('RHOLIQ',),
    mc_mater       = None,
    modelisation   = ('KIT_HH','KIT_HHM','KIT_HM','KIT_THHM','KIT_THH',
        'KIT_THM','KIT_THV',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('SANS_OBJET',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
