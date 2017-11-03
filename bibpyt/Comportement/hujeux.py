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

# person_in_charge: alexandre.foucault at edf.fr

from cata_comportement import LoiComportement

loi = LoiComportement(
    nom            = 'HUJEUX',
    lc_type        = ('MECANIQUE',),
    doc            =   """Relation de comportement élasto-plastique cyclique pour la mécanique
   des sols (géomatériaux granulaires : argiles sableuses, normalement consolidées
   ou sur-consolidées, graves) (Cf. [R7.01.23] pour plus de détails).
   Ce modèle est un modèle multicritère qui comporte un mécanisme élastique non
   linéaire, trois mécanismes plastiques déviatoires et un mécanisme plastique isotrope.
   Pour faciliter l'intégration de ce modèle, on peut utiliser le redécoupage
   automatique local du pas de temps (ITER_INTE_PAS)"""            ,
    num_lc         = 34,
    nb_vari        = 50,
    nom_vari       = ('FECRDVM1','FECRDVM2','FECRDVM3','FECRISM1','FECRDVC1',
        'FECRDVC2','FECRDVC3','FECRISC1','HIS9','HIS10',
        'HIS11','HIS12','HIS13','HIS14','HIS15',
        'HIS16','HIS17','HIS18','HIS19','HIS20',
        'HIS21','HIS22','EPSPVOL','INDETAM1','INDETAM2',
        'INDETAM3','INDETAM4','INDETAC1','INDETAC2','INDETAC3',
        'INDETAC4','CRITHILL','DETOPTG','HIS34','NBITER',
        'XHYZ1','XHYZ2','THYZ1','THYZ2','RHYZ',
        'XHXZ1','XHXZ2','THXZ1','THXZ2','RHXZ',
        'XHXY1','XHXY2','THXY1','THXY2','RHYZ',
        ),
    mc_mater       = ('ELAS','HUJEUX',),
    modelisation   = ('3D','THM','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC','GROT_GDEP','GDEF_LOG',),
    algo_inte      = ('NEWTON','NEWTON_PERT','NEWTON_RELI','SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('No',),
    exte_vari      = None,
)
