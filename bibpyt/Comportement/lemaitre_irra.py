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
    nom            = 'LEMAITRE_IRRA',
    doc            =   """Relation de comportement de fluage et de grandissement sous irradiation pour les assemblages combustibles.
   Le champ de fluence est défini par le mot-clé AFFE_VARC de la commande AFFE_MATERIAU.
   Le grandissement ne se faisant que selon une direction, il est nécessaire dans les cas 3D et 2D de donner la
   direction du grandissement par l'opérande ANGL_REP du mot clé MASSIF de l'opérateur AFFE_CARA_ELEM.
   Pour les poutres, le fluage et le grandissement n'ont lieu que dans le sens axial de la poutre :
   dans les autres directions, le comportement est élastique. Le schéma d'intégration est DEKKER ou semi-DEKKER,
   mais on conseille d'utiliser une intégration semi-DEKKER c'est-à-dire PARM_THETA= 0.5,RESO_INTE=DEKKER."""          ,
    num_lc         = 28,
    nb_vari        = 3,
    nom_vari       = ('EPSPEQ','IRVECU','EPSGRD',),
    mc_mater       = ('LEMAITRE_IRRA',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('DEKKER',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
