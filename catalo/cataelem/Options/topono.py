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




PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I, container='MODL!.TOPOSE.HEA',
comment="""  XFEM - SIGNE HEAVISIDE PAR SOUS-ELEMENTS  """)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PHEAVFA  = InputParameter(phys=PHY.N960_I)


PLONGCO  = InputParameter(phys=PHY.N120_I)


PFISNO   = InputParameter(phys=PHY.NEUT_I,
comment=""" PFISNO : CONNECTIVITE DES FISSURES ET DES DDL HEAVISIDE """)


PHEA_NO  = OutputParameter(phys=PHY.N120_I, type='ELNO',
comment="""  XFEM - IDENTIFIANT HEAVISIDE AU NOEUD XFEM  """)


PHEA_SE  = OutputParameter(phys=PHY.N512_I, type='ELEM',
comment="""  XFEM - IDENTIFIANT HEAVISIDE SUR LES SOUS-ELEMENTS XFEM  """)


PHEA_FA  = OutputParameter(phys=PHY.N240_I, type='ELEM',
comment="""  XFEM - IDENTIFIANT HEAVISIDE POUR LES FACETTES DE CONTACT XFEM  """)


TOPONO = Option(
    para_in=(
           PCNSETO,
        SP.PFISCO,
           PFISNO,
           PHEAVFA,
           PHEAVTO,
        SP.PLEVSET,
           PLONCHA,
           PLONGCO,
    ),
    para_out=(
           PHEA_FA,
           PHEA_NO,
           PHEA_SE,
    ),
    condition=(
      CondCalcul('+', ((AT.LXFEM,'OUI'),)),
    ),
    comment=""" TOPONO : CALCUL DU SIGNE HEAVISIDE PAR NOEUD
           POUR LES ELEMENTS X-FEM """,
)
