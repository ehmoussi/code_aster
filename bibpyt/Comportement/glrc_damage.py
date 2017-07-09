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


from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'GLRC_DAMAGE',
    doc            =   """Modèle global de plaque en béton armé capable de représenter son comportement jusqu'à la ruine.
   Contrairement aux modélisations locales où chaque constituant du matériau est modélisé à part, dans les modèles globaux,
   la loi de comportement s'écrit directement en terme de contraintes et de déformations généralisées.
   Les phénomènes pris en compte sont l'élasto-plasticité couplée entre les effets de membrane et de flexion
   (contre une élasto-plasticité en flexion seulement dans GLRC) et l'endommagement en flexion.
   L'endommagement couplé membrane/flexion est traité par GLRC_DM, lequel, par contre, néglige complètement l'élasto-plasticité.
   Pour les précisions sur la formulation du modèle voir [R7.01.31]."""          ,
    num_lc         = 0,
    nb_vari        = 19,
    nom_vari       = ('EPSP1','EPSP2','EPSP3','KHIP1','KHIP2',
        'KHIP3','DISSIP','ENDOFL+','ENDOFL-','DISSENDO',
        'ANGL1','ANGL2','ANGL3','XMEMB1','XMEMB2',
        'XMEMB3','XFLEX1','XFLEX2','XFLEX3',),
    mc_mater       = ('GLRC_DAMAGE','GLRC_ACIER',),
    modelisation   = ('DKTG','Q4GG',),
    deformation    = ('PETIT','GROT_GDEP',),
    algo_inte      = ('NEWTON',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
