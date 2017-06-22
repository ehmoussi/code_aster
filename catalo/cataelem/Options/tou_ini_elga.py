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




PDOMMAG  = OutputParameter(phys=PHY.DOMA_R, type='ELGA')


PEPSI_R  = OutputParameter(phys=PHY.EPSI_R, type='ELGA')


PGEOM_R  = OutputParameter(phys=PHY.GEOM_R, type='ELGA')


PINST_R  = OutputParameter(phys=PHY.INST_R, type='ELGA')


PNEUT_F  = OutputParameter(phys=PHY.NEUT_F, type='ELGA')


PNEUT_R  = OutputParameter(phys=PHY.NEUT_R, type='ELGA')


PPRES_R  = OutputParameter(phys=PHY.PRES_R, type='ELGA')


PSIEF_R  = OutputParameter(phys=PHY.SIEF_R, type='ELGA')


PVARI_R  = OutputParameter(phys=PHY.VARI_R, type='ELGA')


PSOUR_R  = OutputParameter(phys=PHY.SOUR_R, type='ELGA')


PDEPL_R  = OutputParameter(phys=PHY.DEPL_R, type='ELGA')


PFLUX_R  = OutputParameter(phys=PHY.FLUX_R, type='ELGA')


TOU_INI_ELGA = Option(
    para_in=(
    ),
    para_out=(
        SP.PDEPL_C,
           PDEPL_R,
           PDOMMAG,
           PEPSI_R,
        SP.PFACY_R,
           PFLUX_R,
           PGEOM_R,
           PINST_R,
           PNEUT_F,
           PNEUT_R,
           PPRES_R,
           PSIEF_R,
           PSOUR_R,
        SP.PTEMP_R,
        SP.PVALO_R,
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
