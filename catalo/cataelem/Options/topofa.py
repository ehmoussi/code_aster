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




PLSN     = InputParameter(phys=PHY.NEUT_R)


PLST     = InputParameter(phys=PHY.NEUT_R)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PPINTTO  = InputParameter(phys=PHY.N132_R)


PCNSETO  = InputParameter(phys=PHY.N1280I)


PLONCHA  = InputParameter(phys=PHY.N120_I)


PHEAVTO  = InputParameter(phys=PHY.N512_I)


PAINTTO  = InputParameter(phys=PHY.N480_R)


PSTANO   = InputParameter(phys=PHY.N120_I)


PPINTER  = OutputParameter(phys=PHY.N816_R, type='ELEM')


PAINTER  = OutputParameter(phys=PHY.N1360R, type='ELEM')


PCFACE   = OutputParameter(phys=PHY.N720_I, type='ELEM')


PLONGCO  = OutputParameter(phys=PHY.N120_I, type='ELEM')


PBASECO  = OutputParameter(phys=PHY.N2448R, type='ELEM')


PHEAVFA  = OutputParameter(phys=PHY.N960_I, type='ELEM')


TOPOFA = Option(
    para_in=(
           PAINTTO,
           PCNSETO,
        SP.PDECOU,
        SP.PFISCO,
        SP.PGEOMER,
        SP.PGRADLN,
        SP.PGRADLT,
           PHEAVTO,
           PLONCHA,
           PLSN,
           PLST,
           PPINTTO,
           PPMILTO,
           PSTANO,
        SP.PTYPDIS,
    ),
    para_out=(
           PAINTER,
           PBASECO,
           PCFACE,
        SP.PGESCLA,
           PHEAVFA,
           PLONGCO,
           PPINTER,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),(AT.LXFEM,'OUI'),)),
      CondCalcul('+', ((AT.PHENO,'TH'),(AT.BORD,'0'),(AT.LXFEM,'OUI'),)),
    ),
    comment=""" TOPOFA (MOT-CLE: CONTACT): CALCUL DU DE LA TOPOLOGIE DES
           FACETTES DE CONTACT AVEC X-FEM ET LE METHODE CONTINUE """,
)
