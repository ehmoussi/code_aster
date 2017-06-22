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

# person_in_charge: josselin.delmas at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PVOISIN  = InputParameter(phys=PHY.VOISIN,
comment="""  PVOISIN : VOISINS DE L ELEMENT  """)


PPINTTO  = InputParameter(phys=PHY.N132_R,
comment="""  PPINTTO : XFEM, POINTS D INTERSECTION  """)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PCVOISX  = InputParameter(phys=PHY.N120_I,
comment="""  PCVOISX : XFEM, SD VOISIN POUR LES SOUS-ELEMENTS  """)


PCONTSER = InputParameter(phys=PHY.N1920R,
comment="""  PCONTSER : XFEM, CONTRAINTES AUX NOEUDS DES SOUS-ELEMENTS  """)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PERREUR  = OutputParameter(phys=PHY.ERRE_R, type='ELEM',
comment="""  PERREUR : ESTIMATEUR D ERREUR  """)


ERME_ELEM = Option(
    para_in=(
           PCNSETO,
        SP.PCONTNM,
        SP.PCONTNO,
           PCONTSER,
           PCVOISX,
        SP.PDEPLAR,
        SP.PDEPLMR,
        SP.PERREM,
        SP.PFFVOLU,
        SP.PFORCE,
        SP.PFRVOLU,
        SP.PGEOMER,
        SP.PGRDCA,
           PLONCHA,
        SP.PMATERC,
        SP.PPESANR,
           PPINTTO,
           PPMILTO,
        SP.PPRESS,
        SP.PROTATR,
        SP.PTEMPSR,
           PVOISIN,
    ),
    para_out=(
           PERREUR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
    ),
    comment="""  ERME_ELEM :
    ESTIMATEUR D ERREUR EN RESIDU
    PRODUIT UN CHAMP PAR ELEMENT  """,
)
