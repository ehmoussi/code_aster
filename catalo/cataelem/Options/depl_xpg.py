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



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PXFGEOM  = InputParameter(phys=PHY.GEOM_R)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I)


PBASLOR  = InputParameter(phys=PHY.NEUT_R)


PLSN     = InputParameter(phys=PHY.NEUT_R)


PLST     = InputParameter(phys=PHY.NEUT_R)


PHEA_NO  = InputParameter(phys=PHY.N120_I,
comment="""  XFEM - IDENTIFIANT HEAVISIDE AU NOEUD XFEM  """)

PSTANO   = InputParameter(phys=PHY.N120_I)



DEPL_XPG = Option(
    para_in=(
           PBASLOR,
        SP.PDEPLNO,
           PHEAVTO,
           PHEA_NO,
           PLONCHA,
           PLSN,
           PLST,
           PXFGEOM,
           PSTANO,
        SP.PMATERC,
        SP.PGEOMER,
    ),
    para_out=(
        SP.PDEPLPG,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),(AT.LXFEM,'OUI'),)),
    ),
    comment=""" CALCUL DES COORDONNEES DES POINTS DE GAUSS DES FAMILLES XFEM_... """,
)
