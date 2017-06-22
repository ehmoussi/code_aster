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

# person_in_charge: mickael.abbas at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT


PPINTER = InputParameter(phys=PHY.N816_R)


PLONGCO = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
                         comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PGESCLO = InputParameter(phys=PHY.N816_R)


PLST = InputParameter(phys=PHY.NEUT_R)


PFISNO = InputParameter(phys=PHY.NEUT_I)


PHEA_NO = InputParameter(phys=PHY.N120_I)


PHEA_FA = InputParameter(phys=PHY.N240_I)

PBASLOR  = InputParameter(phys=PHY.NEUT_R)

PSTANO   = InputParameter(phys=PHY.N120_I)

PLSN     = InputParameter(phys=PHY.NEUT_R)

GEOM_FAC = Option(
    para_in=(
        SP.NOMFIS,
        SP.PDEPLA,
        PFISNO,
        PGESCLO,
        PHEA_FA,
        PHEA_NO,
        PLONGCO,
        PLST,
        PPINTER,
        SP.PGEOMER,
        SP.PMATERC,
        PBASLOR,
        PSTANO,
        PLSN,
    ),
    para_out=(
        SP.PNEWGEM,
        SP.PNEWGES,
    ),
    condition=(
        CondCalcul(
            '+', ((AT.PHENO, 'ME'), (AT.LXFEM, 'OUI'), (AT.CONTACT, 'OUI'),)),
    ),
)
