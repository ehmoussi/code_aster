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




PLST     = InputParameter(phys=PHY.NEUT_R)


PPINTER  = InputParameter(phys=PHY.N816_R)


PAINTER  = InputParameter(phys=PHY.N1360R)


PCFACE   = InputParameter(phys=PHY.N720_I)


PLONGCO  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PBASECO  = InputParameter(phys=PHY.N2448R)


PCOHESO  = OutputParameter(phys=PHY.NEUT_R, type='ELNO')

# Attention : les champs PINDCOO, PINDMEM, PINDCOT et PCOHESO
# sont des champs a sous-points
# pour les elements de contact XFEM (xhc,xhtc,xtc)

PCOMPOR  = InputParameter(phys=PHY.COMPOR,
comment=""" UTILE POUR HM-XFEM """)


PSTANO   = InputParameter(phys=PHY.N120_I,
comment=""" XFEM - STATUT DES NOEUDS (ENRICHISSEMENT) """)


PLSN     = InputParameter(phys=PHY.NEUT_R,
comment=""" XFEM - VALEURS DE LA LEVEL SET NORMALE """)


PFISNO   = InputParameter(phys=PHY.NEUT_I,
comment=""" PFISNO : CONNECTIVITE DES FISSURES ET DES DDL HEAVISIDE """)


PHEA_FA  = InputParameter(phys=PHY.N240_I,
comment="""  XFEM - IDENTIFIANT HEAVISIDE POUR LES FACETTES DE CONTACT XFEM  """)


PHEA_NO  = InputParameter(phys=PHY.N120_I,
comment="""  XFEM - IDENTIFIANT HEAVISIDE AU NOEUD XFEM  """)


XCVBCA_MORTAR = Option(
    para_in=(
           PAINTER,
           PBASECO,
           PCFACE,
        SP.PCOHES,
        SP.PDEPL_P,
        SP.PDEPL_M,
        SP.PDONCO,
        SP.PGEOMER,
        SP.PGLISS,
        SP.PINDCOI,
           PLONGCO,
           PLST,
           PLSN,
           PCOMPOR,
           PSTANO,
           PFISNO,
        SP.PHEAVNO,
        SP.PFISCO,
           PHEA_FA,
           PHEA_NO,
        SP.PMATERC,
        SP.PMEMCON,
           PPINTER,
    ),
    para_out=(
           PCOHESO,
        SP.PINCOCA,
        SP.PINDCOO,
        SP.PINDMEM,
    ),
    condition=(
      CondCalcul('+', ((AT.LXFEM,'OUI'),(AT.CONTACT,'OUI'),)),
    ),
)
