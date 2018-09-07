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

# person_in_charge: david.haboussa at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'ROUSS_VISC',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement élasto-visco-plastique de G.Rousselier, en petites déformations.
   Elle permet de rendre compte de la croissance des cavités et de décrire la rupture ductile.
   Pour faciliter l'intégration de ce modèle, il est conseillé d'utiliser le redécoupage automatique local du pas de temps (ITER_INTE_PAS).
   Pour l'intégration de cette loi, une theta-méthode est disponible et on conseille d'utiliser une intégration semi-NEWTON_1D c'est-à-dire : PARM_THETA = 0.5."""              ,
    num_lc         = 30,
    nb_vari        = 5,
    nom_vari       = ('EPSPEQ','POROSITE','DISSIP','EBLOC','INDIPLAS',
        ),
    mc_mater       = ('ELAS','ROUSSELIER','VISC_SINH',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON_1D',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
