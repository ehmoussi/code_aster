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
    nom            = 'MONOCRISTAL',
    lc_type        = ('MECANIQUE',),
    doc            =   """Ce modèle permet de décrire le comportement d'un monocristal dont les relations de comportement
            sont fournies via le concept compor, issu de DEFI_COMPOR.
            Le nombre de variables internes est fonction des choix effectués dans DEFI_COMPOR ;
            pour plus de précisions consulter [R5.03.11]."""              ,
    num_lc         = 137,
    nb_vari        = 0,
    nom_vari       = None,
    mc_mater       = None,
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','SIMO_MIEHE',),
    algo_inte      = ('NEWTON','NEWTON_RELI','RUNGE_KUTTA','NEWTON_PERT',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = ('GRADVELO',),
    deform_ldc     = ('OLD',),
)
