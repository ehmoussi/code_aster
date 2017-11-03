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
    nom            = 'BETON_RAG',
    lc_type        = ('MECANIQUE',),
    doc            =   """Loi RAG pour le beton"""            ,
    num_lc         = 44,
    nb_vari        = 65,
    nom_vari       = ('ERS','EIS','EID11','ERD11','EID22',
        'ERD22','EID33','ERD33','EID12','ERD12',
        'EID31','ERD31','EID23','ERD23','ENDOT11',
        'ENDOT22','ENDOT33','ENDOT12','ENDOT13','ENDOT23',
        'ENDOC0','SUT11','SUT22','SUT33','SUT12',
        'SUT13','SUT23','SUC','PW','PCH',
        'ARAG','ESI','ESS','EDI11','EDS11',
        'EDI22','EDS22','EDI33','EDS33','EDI12',
        'EDS12','EDI13','EDS13','EDI23','EDS23',
        'SEF11','SEF22','SEF33','SEF12','SEF13',
        'SEF23','EVP11','EVP22','EVP33','EVP12',
        'EVP13','EVP23','BT11','BT22','BT33',
        'BT12','BT13','BT23','BC','PEFFRAG',
        ),
    mc_mater       = ('ELAS','BETON_RAG',),
    modelisation   = ('3D','AXIS','D_PLAN',),
    deformation    = ('PETIT','PETIT_REAC',),
    algo_inte      = ('SPECIFIQUE',),
    type_matr_tang = ('PERTURBATION','VERIFICATION',),
    proprietes     = None,
    syme_matr_tang = ('Yes',),
    exte_vari      = None,
)
