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

# person_in_charge: aurore.parrot at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'ROUSS_PR',
    doc            =   """Relation de comportement élasto-plastique de G.Rousselier, en petites déformations.
   Elle permet de rendre compte de la croissance des cavités et de décrire la rupture ductile, cf. [R5.03.06]).
   On peut également prendre en compte la nucléation des cavités.
   Il faut alors renseigner le paramètre AN (mot clé non activé pour le modèle ROUSSELIER et ROUSS_VISC) sous ROUSSELIER(_FO).
   Pour faciliter l'intégration de ce modèle, il est conseillé d'utiliser le redécoupage automatique local du pas de temps (mot clé ITER_INTE_PAS)"""      ,
    num_lc         = 30,
    nb_vari        = 5,
    nom_vari       = ('EPSPEQ','POROSITE','DISSIP','EBLOC','INDIPLAS',
        ),
    mc_mater       = ('ELAS','ROUSSELIER',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('NEWTON_1D',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
)
