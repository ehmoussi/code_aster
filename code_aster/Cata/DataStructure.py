# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

"""
This package is only used to check the *legacy* syntax.

It is not important to use the real class (defined in Cython).
Their definitions are sufficient.
"""

# Objects provided by Noyau from Eficas
class ASSD(object):
    pass

class not_checked(ASSD):
    pass

class formule(ASSD):
    pass

class formule_c(formule):
    pass

# Objects provided in the header of cata.py
class GEOM(object):
    pass

class grma(GEOM):
    pass

class grno(GEOM):
    pass

class ma(GEOM):
    pass

class no(GEOM):
    pass

# To be more consistent with new names
DataStructure = ASSD
MeshEntity = GEOM

# Copy of `allco.capy`.
# It can not be used as is because ASSD is declared in `accas.capy`
# ------- Begin of copy -------
# List built using `capy` files::
#   egrep -h '^class' catapy/entete/co_* | sed -e 's/:$/:\n    pass\n/g'

class cabl_precont(ASSD):
    pass

class cara_elem(ASSD):
    pass

class cham_gd_sdaster(ASSD):
    pass

class carte_sdaster(cham_gd_sdaster):
    pass

class cham_elem(cham_gd_sdaster):
    pass

class cham_no_sdaster(cham_gd_sdaster):
    pass

class post_comp_cham_no :
    pass

class post_comp_cham_el :
    pass

class cham_mater(ASSD):
    pass

class char_acou(ASSD):
    pass

class char_cine_acou(ASSD):
    pass

class char_cine_meca(ASSD):
    pass

class char_cine_ther(ASSD):
    pass

class char_contact(ASSD):
    pass

class char_meca(ASSD):
    pass

class char_ther(ASSD):
    pass

class compor_sdaster(ASSD):
    pass

class corresp_2_mailla(ASSD):
    pass

class courbe_sdaster(ASSD):
    pass

class entier(ASSD):
    pass

class fiss_xfem(ASSD):
    pass

class fonction_class(ASSD):
    pass

class fonction_sdaster(fonction_class):
    pass

class fonction_c(fonction_class):
    pass

class nappe_sdaster(fonction_class):
    pass

class fond_fiss(ASSD):
    pass

class gfibre_sdaster(ASSD):
    pass

class interf_dyna_clas(ASSD):
    pass

class interspectre(ASSD):
    pass

class list_inst(ASSD):
    pass

class listis_sdaster(ASSD):
    pass

class listr8_sdaster(ASSD):
    pass

class macr_elem_dyna(ASSD):
    pass

class macr_elem_stat(ASSD):
    pass

class maillage_sdaster(ASSD):
    pass

class grille_sdaster(maillage_sdaster):
    pass

class squelette(maillage_sdaster):
    pass

class mater_sdaster(ASSD):
    pass

class matr_asse(ASSD):
    pass

class matr_asse_gd(matr_asse):
    pass

class matr_asse_depl_c(matr_asse_gd):
    pass

class matr_asse_depl_r(matr_asse_gd):
    pass

class matr_asse_pres_c(matr_asse_gd):
    pass

class matr_asse_pres_r(matr_asse_gd):
    pass

class matr_asse_temp_c(matr_asse_gd):
    pass

class matr_asse_temp_r(matr_asse_gd):
    pass

class matr_asse_gene(ASSD):
    pass

class matr_asse_gene_r(matr_asse_gene):
    pass

class matr_asse_gene_c(matr_asse_gene):
    pass

class matr_elem(ASSD):
    pass

class matr_elem_depl_c(matr_elem):
    pass

class matr_elem_depl_r(matr_elem):
    pass

class matr_elem_pres_c(matr_elem):
    pass

class matr_elem_temp_r(matr_elem):
    pass

class melasflu_sdaster(ASSD):
    pass

class mode_cycl(ASSD):
    pass

class modele_gene(ASSD):
    pass

class modele_sdaster(ASSD):
    pass

class nume_ddl_gene(ASSD):
    pass

class nume_ddl_sdaster(ASSD):
    pass

class reel(ASSD):
    pass

class resultat_sdaster(ASSD):
    pass

class resultat_jeveux(resultat_sdaster):
    pass

class comb_fourier(resultat_sdaster): pass
class fourier_elas(resultat_sdaster): pass
class fourier_ther(resultat_sdaster): pass
class mult_elas(resultat_sdaster): pass
class theta_geom(resultat_sdaster): pass
class evol_sdaster(resultat_sdaster): pass
class evol_char(evol_sdaster): pass
class evol_elas(evol_sdaster): pass
class evol_noli(evol_sdaster): pass
class evol_ther(evol_sdaster): pass
class evol_varc(evol_sdaster): pass
class dyna_gene(ASSD):
    pass

class dyna_phys(resultat_sdaster):
    pass

class harm_gene  (dyna_gene) : pass
class tran_gene  (dyna_gene) : pass
class acou_harmo (dyna_phys) : pass
class dyna_harmo (dyna_phys) : pass
class dyna_trans (dyna_phys) : pass
class mode_acou  (dyna_phys) : pass
class mode_flamb (dyna_phys) : pass
class mode_meca  (dyna_phys) : pass
class mode_meca_c(mode_meca) : pass
class mode_gene  (dyna_phys) : pass
class sd_partit(ASSD):
    pass

class spectre_sdaster(ASSD):
    pass

class surface_sdaster(ASSD):
    pass

class table_sdaster(ASSD):
    pass

class table_fonction(table_sdaster):
    pass

class table_jeveux(table_sdaster):
    pass

class table_fonction(table_sdaster):
    pass

class table_container(table_sdaster):
    pass

class type_flui_stru(ASSD):
    pass

class vect_asse_gene(ASSD):
    pass

class vect_elem(ASSD):
    pass

class vect_elem_depl_r(vect_elem):
    pass

class vect_elem_pres_r(vect_elem):
    pass

class vect_elem_pres_c(vect_elem):
    pass

class vect_elem_temp_r(vect_elem):
    pass
