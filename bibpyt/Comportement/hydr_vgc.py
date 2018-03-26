# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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


from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'HYDR_VGC',
    lc_type        = ('HYDRAULIQUE',),
    doc            =   """Loi de comportement hydraulique, si le comportement mécanique est sans endommagement :
   Ici et uniquement pour les lois de couplage liquide/gaz 'LIQU_GAZ', 'LIQU_AD_VAPE_GAZ' et 'LIQU_AD_GAZ',
   les courbes de saturation, de perméabilités relatives à l'eau  et leur dérivées sont définies par
   le modèle de Mualem Van-Genuchten. Celle au gaz par une loi cubique """              ,
    num_lc         = 0,
    nb_vari        = 1,
    nom_vari       = ('RHOLIQ',),
    mc_mater       = None,
    modelisation   = ('KIT_HH','KIT_HHM','KIT_THHM','KIT_THH',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('SANS_OBJET',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
