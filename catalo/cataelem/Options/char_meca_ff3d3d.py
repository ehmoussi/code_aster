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

# person_in_charge: xavier.desroches at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT


CHAR_MECA_FF3D3D = Option(
    para_in=(
        SP.PFF3D3D,
        SP.PGEOMER,
        SP.PTEMPSR,
    ),
    para_out=(
        SP.PVECTUR,
    ),
    condition=(
# L'attribut INTERFACE='OUI' designe les elements "ecrases".
# Ils n'ont pas de "volume" et ne peuvent pas calculer ce chargement.
# La modelisation 3D_DIL ('D3D') se "superpose" a une autre modelisation.
# Ce n'est pas a elle de calculer les chargements repartis :
        CondCalcul(
            '+', ((AT.PHENO, 'ME'), (AT.BORD, '0'), (AT.DIM_TOPO_MODELI, '3'),)),
        CondCalcul('-', ((AT.PHENO, 'ME'), (AT.INTERFACE, 'OUI'),)),
        CondCalcul('-', ((AT.PHENO, 'ME'), (AT.MODELI, 'D3D'),)),
    ),
    comment=""" CHAR_MECA_FF3D3D (MOT-CLE : FORCE_INTERNE): CALCUL DU SECOND
           MEMBRE ELEMENTAIRE CORRESPONDANT A DES FORCES INTERNES APPLIQUEES
           A UN DOMAINE 3D. LES FORCES SONT DONNEES SOUS FORME DE FONCTION """,
)
