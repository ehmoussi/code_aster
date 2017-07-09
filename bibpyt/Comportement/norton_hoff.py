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

# person_in_charge: sylvie.michel-ponnelle at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'NORTON_HOFF',
    doc            =   """Loi de visco-plasticité  indépendante de la température, régularisant la loi rigide-plastique de Von Mises
   à utiliser pour le calcul de charges limites de structures, à seuil de VON MISES.
   Le seul paramètre matériau est la limite d'élasticité à renseigner dans l'opérateur DEFI_MATERIAU [U4.43.01]
   sous le mot-clé ECRO_LINE (Cf. [R7.07.01] et [R5.03.12] pour plus de détails).
   Pour le calcul de la charge limite, il existe un mot clé spécifique sous PILOTAGE pour ce modèle
   (voir mot clé PILOTAGE='ANA_LIM' de STAT_NON_LINE [U4.51.03]).
   Il est fortement conseillé d'employer de la recherche linéaire (voir mot clé RECH_LINEAIRE de STAT_NON_LINE [U4.51.03]).
   En effet, le calcul de la charge limite requiert beaucoup d'itérations de recherche linéaire (de l'ordre de 50)
   et d'itérations de Newton (de l'ordre de 50)."""          ,
    num_lc         = 17,
    nb_vari        = 1,
    nom_vari       = ('VIDE',),
    mc_mater       = ('ECRO_LINE',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('ANALYTIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
