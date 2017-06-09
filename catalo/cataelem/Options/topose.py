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




PPINTTO  = OutputParameter(phys=PHY.N132_R, type='ELEM')


PCNSETO  = OutputParameter(phys=PHY.N1280I, type='ELEM')


PHEAVTO  = OutputParameter(phys=PHY.N512_I, type='ELEM')


PLONCHA  = OutputParameter(phys=PHY.N120_I, type='ELEM')


PPMILTO  = OutputParameter(phys=PHY.N792_R, type='ELEM')


PAINTTO  = OutputParameter(phys=PHY.N480_R, type='ELEM')


PJONCNO  = OutputParameter(phys=PHY.N120_I, type='ELEM')


TOPOSE = Option(
    para_in=(
        SP.PFISCO,
        SP.PGEOMER,
        SP.PLEVSET,
    ),
    para_out=(
           PAINTTO,
           PCNSETO,
           PHEAVTO,
           PLONCHA,
           PPINTTO,
           PPMILTO,
           PJONCNO,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),(AT.LXFEM,'OUI'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'-1'),(AT.LXFEM,'OUI'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'0'),(AT.LXFEM,'OUI'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'-1'),(AT.LXFEM,'OUI'),)),
    ),
    comment=""" TOPOSE : CALCUL DU DE LA TOPOLOGIE DES
           SOUS-ELEMENTS POUR L INTEGRATION AVEC X-FEM """,
)
