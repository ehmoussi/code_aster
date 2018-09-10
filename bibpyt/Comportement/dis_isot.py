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

# person_in_charge: jean-luc.flejou at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'DIS_ECRO_TRAC',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement isotrope pour les éléments discrets"""              ,
    num_lc         = 0,
    nb_vari        = 17,
    nom_vari       = ('FORCEX', 'FORCEY', 'FORCEZ', 'DEPLX',  'DEPLY',  'DEPLZ',  'DISSTHER',
                      'PCUM',   'DEPLPX', 'DEPLPY', 'DEPLPZ', 'FORCXX', 'FORCXY', 'FORCXZ',
                      'RAIDEX', 'RAIDEY', 'RAIDEZ',),
    mc_mater       = None,
    modelisation   = ('DIS_T','DIS_TR','2D_DIS_T','2D_DIS_TR',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP',),
    algo_inte      = ('SPECIFIQUE',),
    type_matr_tang = None,
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
    deform_ldc     = ('OLD',),
)
#
# Variable existante
#   "DISSTHER": _(u"dissipation Thermodynamique"),
#
# Nouvelles variables internes
#   "FORCEX":   _(u"DIS_ECRO_TRAC : Force suivant x local."),
#   "FORCEY":   _(u"DIS_ECRO_TRAC : Force suivant y local."),
#   "FORCEZ":   _(u"DIS_ECRO_TRAC : Force suivant z local."),
#   "DEPLX":    _(u"DIS_ECRO_TRAC : Déplacement différentiel, suivant x local."),
#   "DEPLY":    _(u"DIS_ECRO_TRAC : Déplacement différentiel, suivant y local."),
#   "DEPLZ":    _(u"DIS_ECRO_TRAC : Déplacement différentiel, suivant z local."),
#   "PCUM" :    _(u"DIS_ECRO_TRAC : Déplacement anélastique cumulé"),
#   "DEPLPX":   _(u"DIS_ECRO_TRAC : Déplacement anélastique différentiel, suivant x local."),
#   "DEPLPY":   _(u"DIS_ECRO_TRAC : Déplacement anélastique différentiel, suivant y local."),
#   "DEPLPZ":   _(u"DIS_ECRO_TRAC : Déplacement anélastique différentiel, suivant z local."),
#   "FORCXX":   _(u"DIS_ECRO_TRAC : Force écrouissage cinématique suivant x local."),
#   "FORCXY":   _(u"DIS_ECRO_TRAC : Force écrouissage cinématique suivant y local."),
#   "FORCXZ":   _(u"DIS_ECRO_TRAC : Force écrouissage cinématique suivant z local."),
#   "RAIDEX":   _(U"DIS_ECRO_TRAC : Raideur tangente du discret suivant x local"),
#   "RAIDEY":   _(U"DIS_ECRO_TRAC : Raideur tangente du discret suivant y local"),
#   "RAIDEZ":   _(U"DIS_ECRO_TRAC : Raideur tangente du discret suivant z local"),
