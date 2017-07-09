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

# person_in_charge: mickael.abbas at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'ELAS_HYPER',
    doc            =   """Relation de comportement hyper-élastique généralisant le modèle de Mooney-Rivlin généralisé
            Sous sa version incrémentale, elle permet de prendre en compte des déplacements
            et contraintes initiaux donnés sous le mot clé ETAT_INIT.
            Cette relation n'est supportée qu'en grandes déformations (DEFORMATION='GREEN') cf.[R5.03.23]. """          ,
    num_lc         = 19,
    nb_vari        = 1,
    nom_vari       = ('VIDE',),
    mc_mater       = ('ELAS_HYPER',),
    modelisation   = ('3D','C_PLAN','D_PLAN',),
    deformation    = ('GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = ('COMP_ELAS',),
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
