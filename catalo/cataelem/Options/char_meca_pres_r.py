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




PNBSP_I  = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)


PCAORIE  = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PPINTTO  = InputParameter(phys=PHY.N132_R)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)

PBASLOR  = InputParameter(phys=PHY.NEUT_R)

PLSN     = InputParameter(phys=PHY.NEUT_R)


PLST     = InputParameter(phys=PHY.NEUT_R)


PPINTER  = InputParameter(phys=PHY.N816_R)


PAINTER  = InputParameter(phys=PHY.N1360R)


PCFACE   = InputParameter(phys=PHY.N720_I)


PLONGCO  = InputParameter(phys=PHY.N120_I)


PSTANO   = InputParameter(phys=PHY.N120_I)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PBASECO  = InputParameter(phys=PHY.N2448R)


PFISNO   = InputParameter(phys=PHY.NEUT_I)


PHEA_FA  = InputParameter(phys=PHY.N240_I)


PHEA_NO  = InputParameter(phys=PHY.N120_I)


PHEA_SE  = InputParameter(phys=PHY.N512_I)


CHAR_MECA_PRES_R = Option(
    para_in=(
           PAINTER,
           PBASECO,
        SP.PCACOQU,
        SP.PCAGEPO,
           PCAORIE,
           PCFACE,
           PCNSETO,
           PFISNO,
        SP.PGEOMER,
           PHEAVTO,
           PHEA_FA,
           PHEA_NO,
           PHEA_SE,
           PLONCHA,
           PLONGCO,
           PLSN,
           PLST,
           PNBSP_I,
           PPINTER,
           PPINTTO,
           PPMILTO,
        SP.PPRESSR,
           PSTANO,
        SP.PTEMPSR,
        SP.PMATERC,
           PBASLOR,
    ),
    para_out=(
        SP.PVECTUR,
    ),
    condition=(
#     Ce chargement concerne le bord des elements "massifs" :
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'-1'),)),

#     Ce chargement concerne les elements de coque et tuyau :
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),(AT.COQUE,'OUI'),)),
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),(AT.TUYAU,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.BORD,'-1'),(AT.COQUE,'OUI'),)),

#     Les 3 modelisations suivantes (grilles et membranes) sont affectees sur des mailles
#     duppliquees. Il ne faut pas que le chargement soit pris en compte plusieurs fois :
      #CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'GRM'),)),
      #CondCalcul('-', ((AT.PHENO,'ME'),(AT.MODELI,'GRC'),)),
#     => l'option est ajoutée sur ces éléments, elle pointe sur te580 afin de
#        vérifier que le chargement est nul
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.MODELI,'MMB'),)),


#     Ce chargement concerne les elements XFEM "massifs" :
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),(AT.LXFEM,'OUI'),)),
    ),
    comment=""" Second membre pour une pression """,
)
