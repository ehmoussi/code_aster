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

# person_in_charge: samuel.geniaut at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'VISCOCHAB',
    doc            =   """Modèle élastoviscoplastique de Lemaitre-Chaboche avec effet de
   mémoire et restauration.
   Ce modèle s'emploie avec les mots clés DEFORMATION = PETIT ou PETIT_REAC."""          ,
    num_lc         = 32,
    nb_vari        = 28,
    nom_vari       = ('VISCHA1','VISCHA2','VISCHA3','VISCHA4','VISCHA5',
        'VISCHA6','VISCHA7','VISCHA8','VISCHA9','VISCHA10',
        'VISCHA11','VISCHA12','VISCHA13','VISCHA14','VISCHA15',
        'VISCHA16','VISCHA17','VISCHA18','VISCHA19','VISCHA20',
        'VISCHA21','VISCHA22','VISCHA23','VISCHA24','VISCHA25',
        'VISCHA26','VISCHA27','VISCHA28',),
    mc_mater       = ('ELAS','VISCOCHAB',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON','NEWTON_RELI','RUNGE_KUTTA',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
