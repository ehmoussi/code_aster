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

# person_in_charge: david.haboussa at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'ROUSSELIER',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement élasto-plastique de G.Rousselier en grandes déformations.
   Elle permet de rendre compte de la croissance des cavités et de décrire la rupture ductile.
   Pour faciliter l'intégration de ce modèle, il est conseillé d'utiliser systématiquement le redécoupage global du pas de temps (SUBD_PAS)."""            ,
    num_lc         = 36,
    nb_vari        = 9,
    nom_vari       = ('EPSPEQ','POROSITE','INDIPLAS','EPSEXX','EPSEYY',
        'EPSEZZ','EPSEXY','EPSEXZ','EPSEYZ',),
    mc_mater       = ('ELAS','ROUSSELIER',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('SIMO_MIEHE',),
    algo_inte      = ('NEWTON_1D',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
