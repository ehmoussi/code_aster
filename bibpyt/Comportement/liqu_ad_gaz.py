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


from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'LIQU_AD_GAZ',
    doc            =   """Loi de comportement pour un milieu poreux non saturé eau/vapeur/air sec/air dissous
   avec changement de phase (Cf. [R7.01.11] pour plus de détails)."""          ,
    num_lc         = 10,
    nb_vari        = 5,
    nom_vari       = ('POROSITE','PVP','SATLIQ','PRE1','PRE2',
        ),
    mc_mater       = ('THM_LIQ','THM_VAPE','THM_GAZ','THM_AIR_DISS',),
    modelisation   = ('KIT_HH','KIT_HHM','KIT_HM','KIT_THHM','KIT_THH',
        'KIT_THM','KIT_THV',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('SANS_OBJET',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
