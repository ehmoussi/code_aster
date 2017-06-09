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

# person_in_charge: sarah.plessis at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'BARCELONE',
    doc            =   """Relation décrivant le comportement mécanique élasto-plastique des sols non saturés
            couplé au comportement hydraulique (Cf. [R7.01.14] pour plus de détail).
            Ce modèle se ramène au modèle de Cam_Clay dans le cas saturé. Deux critères interviennent :
            un critère de plasticité mécanique (celui de Cam_Clay)
            et un critère hydrique contrôlé par la succion (ou pression capillaire).
            Ce modèle doit être utilisé dans des relations KIT_HHM ou KIT_THHM."""      ,
    num_lc         = 0,
    nb_vari        = 5,
    nom_vari       = ('PCR','INDIPLAS','SEUILHYD','INDIHYDR','COHESION',
        ),
    mc_mater       = ('ELAS','CAM_CLAY','BARCELONE',),
    modelisation   = ('KIT_HHM','KIT_THHM',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON_1D',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
