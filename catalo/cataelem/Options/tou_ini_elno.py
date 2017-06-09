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

# person_in_charge: jacques.pellet at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT




PDOMMAG  = OutputParameter(phys=PHY.DOMA_R, type='ELNO')


PEPSI_R  = OutputParameter(phys=PHY.EPSI_R, type='ELNO')


PGEOM_R  = OutputParameter(phys=PHY.GEOM_R, type='ELNO')


PINST_R  = OutputParameter(phys=PHY.INST_R, type='ELNO')


PNEUT_F  = OutputParameter(phys=PHY.NEUT_F, type='ELNO')


PNEUT_R  = OutputParameter(phys=PHY.NEUT_R, type='ELNO')


PPRES_R  = OutputParameter(phys=PHY.PRES_R, type='ELNO')


PSIEF_R  = OutputParameter(phys=PHY.SIEF_R, type='ELNO')


PVARI_R  = OutputParameter(phys=PHY.VARI_R, type='ELNO')


PSOUR_R  = OutputParameter(phys=PHY.SOUR_R, type='ELNO')


PHYDRPM  = OutputParameter(phys=PHY.HYDR_R, type='ELNO')


PFLUX_R  = OutputParameter(phys=PHY.FLUX_R, type='ELNO')


TOU_INI_ELNO = Option(
    para_in=(
    ),
    para_out=(
           PDOMMAG,
           PEPSI_R,
           PFLUX_R,
           PGEOM_R,
           PHYDRPM,
           PINST_R,
           PNEUT_F,
           PNEUT_R,
           PPRES_R,
           PSIEF_R,
           PSOUR_R,
           PVARI_R,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),)),
      CondCalcul('+', ((AT.PHENO,'AC'),)),
      CondCalcul('+', ((AT.PHENO,'PR'),)),
      CondCalcul('+', ((AT.LXFEM,'OUI'),)),
    ),
)
