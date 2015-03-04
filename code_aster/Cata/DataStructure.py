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

# TODO: replace by the Cython objects

from code_aster import (
    Mesh, Model, Material, MaterialOnMesh,
    Function,
)

# compatibility layer to avoid changing all the catalogs
cham_mater = MaterialOnMesh
fonction_sdaster = Function
maillage_sdaster = Mesh
mater_sdaster = Material
modele_sdaster = Model


# for the datastructures that are not yet defined
class DataStructure(object):
    pass

class MeshEntity(object):
    pass

grma = MeshEntity
grno = MeshEntity
ma = MeshEntity
no = MeshEntity


acou_harmo = DataStructure
cabl_precont = DataStructure
cara_elem = DataStructure
carte_sdaster = DataStructure
cham_elem = DataStructure
cham_gd_sdaster = DataStructure
cham_no_sdaster = DataStructure
char_acou = DataStructure
char_cine_acou = DataStructure
char_cine_meca = DataStructure
char_cine_ther = DataStructure
char_contact = DataStructure
char_meca = DataStructure
char_ther = DataStructure
comb_fourier = DataStructure
compor_sdaster = DataStructure
corresp_2_mailla = DataStructure
courbe_sdaster = DataStructure
dyna_harmo = DataStructure
dyna_trans = DataStructure
evol_char = DataStructure
evol_elas = DataStructure
evol_noli = DataStructure
evol_sdaster = DataStructure
evol_ther = DataStructure
evol_varc = DataStructure
fonction_c = DataStructure
fond_fiss = DataStructure
formule = DataStructure
formule_c = DataStructure
fourier_elas = DataStructure
fourier_ther = DataStructure
fiss_xfem = DataStructure
gfibre_sdaster = DataStructure
grille_sdaster = DataStructure
harm_gene = DataStructure
interf_dyna_clas = DataStructure
interspectre = DataStructure
list_inst = DataStructure
listis_sdaster = DataStructure
listr8_sdaster = DataStructure
macr_elem_dyna = DataStructure
macr_elem_stat = DataStructure
matr_asse_depl_c = DataStructure
matr_asse_depl_r = DataStructure
matr_asse_gene_c = DataStructure
matr_asse_gene_r = DataStructure
matr_asse_pres_c = DataStructure
matr_asse_pres_r = DataStructure
matr_asse_temp_c = DataStructure
matr_asse_temp_r = DataStructure
matr_elem_depl_c = DataStructure
matr_elem_depl_r = DataStructure
matr_elem_pres_c = DataStructure
matr_elem_pres_r = DataStructure
matr_elem_temp_c = DataStructure
matr_elem_temp_r = DataStructure
melasflu_sdaster = DataStructure
mode_acou = DataStructure
mode_cycl = DataStructure
mode_flamb = DataStructure
mode_gene = DataStructure
mode_meca = DataStructure
mode_meca_c = DataStructure
modele_gene = DataStructure
mult_elas = DataStructure
not_checked = DataStructure
nume_ddl_gene = DataStructure
nume_ddl_sdaster = DataStructure
nappe_sdaster = DataStructure
reel = DataStructure
resultat_sdaster = DataStructure
sd_partit = DataStructure
spectre_sdaster = DataStructure
squelette = DataStructure
surface_sdaster = DataStructure
table_container = DataStructure
table_fonction = DataStructure
table_sdaster = DataStructure
theta_geom = DataStructure
tran_gene = DataStructure
type_flui_stru = DataStructure
vect_asse_gene = DataStructure
vect_elem = DataStructure
