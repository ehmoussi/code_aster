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




PNBSP_I  = OutputParameter(phys=PHY.NBSP_I, type='ELEM')


PERREUR  = OutputParameter(phys=PHY.ERRE_R, type='ELEM')


PPRES_R  = OutputParameter(phys=PHY.PRES_R, type='ELEM')


PSOUR_R  = OutputParameter(phys=PHY.SOUR_R, type='ELEM')


PGEOM_R  = OutputParameter(phys=PHY.GEOM_R, type='ELEM')


PCOEH_R  = OutputParameter(phys=PHY.COEH_R, type='ELEM')


PFLUN_R  = OutputParameter(phys=PHY.FLUN_R, type='ELEM')

TOU_INI_ELEM = Option(
    para_in=(
    ),
    para_out=(
        SP.PCAFI_R,
           PERREUR,
        SP.PFORC_R,
           PGEOM_R,
           PNBSP_I,
        SP.PNEU1_R,
           PPRES_R,
           PSOUR_R,
           PCOEH_R,
           PFLUN_R,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),)),
      CondCalcul('+', ((AT.PHENO,'AC'),)),
      CondCalcul('+', ((AT.PHENO,'PR'),)),
      CondCalcul('+', ((AT.LXFEM,'OUI'),)),
    ),
)
