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


PVARCPR = InputParameter(phys=PHY.VARI_R)


PCOMPOR = InputParameter(phys=PHY.COMPOR)


PCONTRR = InputParameter(phys=PHY.SIEF_R)


PVARIPR = InputParameter(phys=PHY.VARI_R)


PBASLOR = InputParameter(phys=PHY.NEUT_R)


PPINTTO = InputParameter(phys=PHY.N132_R)


PCNSETO = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
                         comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO = InputParameter(phys=PHY.N512_I)


PHEA_NO = InputParameter(phys=PHY.N120_I)


PLONCHA = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
                         comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PLSN = InputParameter(phys=PHY.NEUT_R)


PLST = InputParameter(phys=PHY.NEUT_R)


PPINTER = InputParameter(phys=PHY.N816_R)


PAINTER = InputParameter(phys=PHY.N1360R)


PCFACE = InputParameter(phys=PHY.N720_I)


PLONGCO = InputParameter(phys=PHY.N120_I)


PPMILTO = InputParameter(phys=PHY.N792_R)


PBASECO = InputParameter(phys=PHY.N2448R)


CALC_GTP_F = Option(
    para_in=(
        SP.PACCELE,
        PAINTER,
        PBASECO,
        PBASLOR,
        PCFACE,
        PCNSETO,
        PCOMPOR,
        SP.PCONTGR,
        PCONTRR,
        SP.PCOURB,
        SP.PDEFOPL,
        SP.PDEPINR,
        SP.PDEPLAR,
        SP.PEPSINF,
        SP.PFF1D2D,
        SP.PFF2D3D,
        SP.PFFVOLU,
        SP.PGEOMER,
        PHEAVTO,
        PHEA_NO,
        PLONCHA,
        PLONGCO,
        PLSN,
        PLST,
        SP.PMATERC,
        SP.PPESANR,
        PPINTER,
        PPINTTO,
        PPMILTO,
        SP.PPRESSF,
        SP.PROTATR,
        SP.PSIGINR,
        SP.PSIGISE,
        SP.PTEMPSR,
        SP.PTHETAR,
        PVARCPR,
        SP.PVARCRR,
        PVARIPR,
        SP.PVITESS,
    ),
    para_out=(
        SP.PGTHETA,
    ),
    condition=(
        CondCalcul('+', ((AT.PHENO, 'ME'), (AT.BORD, '0'),)),
        CondCalcul('+', ((AT.PHENO, 'ME'), (AT.BORD, '-1'),)),
        CondCalcul('-', ((AT.PHENO, 'ME'), (AT.DISCRET, 'OUI'),)),
    ),
)
