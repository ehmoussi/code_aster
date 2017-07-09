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
    nom            = 'GAZ',
    doc            =   """Loi de comportement d'un gaz parfait, c'est-à-dire vérifiant la relation P/rho   rho la masse volumique, Mv la masse molaire, R la constante de Boltzman et T la température (Cf. [R7.01.11]).
   Pour milieu saturé uniquement. """          ,
    num_lc         = 0,
    nb_vari        = 1,
    nom_vari       = ('GAZ1',),
    mc_mater       = ('THM_GAZ',),
    modelisation   = ('KIT_HM','KIT_THM',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('SANS_OBJET',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
