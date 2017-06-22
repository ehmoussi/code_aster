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




PPINTTO  = InputParameter(phys=PHY.N132_R)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PXFGEOM  = OutputParameter(phys=PHY.GEOM_R, type='ELGA')


XFEM_XPG = Option(
    para_in=(
           PCNSETO,
        SP.PGEOMER,
           PHEAVTO,
           PLONCHA,
           PPINTTO,
           PPMILTO,
    ),
    para_out=(
           PXFGEOM,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),(AT.LXFEM,'OUI'),)),
    ),
    comment=""" CALCUL DES COORDONNEES DES POINTS DE GAUSS DES FAMILLES XFEM_... """,
)
