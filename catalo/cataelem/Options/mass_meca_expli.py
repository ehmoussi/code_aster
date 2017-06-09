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

# person_in_charge: nicolas.greffet at edf.fr



from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP
import cataelem.Commons.attributes as AT


PVARCPR = InputParameter(phys=PHY.VARI_R)


PCAORIE = InputParameter(phys=PHY.CAORIE, container='CARA!.CARORIEN',
                         comment="""  PCAORIE : ORIENTATION LOCALE D'UN ELEMENT DE POUTRE OU DE TUYAU  """)


PNBSP_I = InputParameter(phys=PHY.NBSP_I, container='CARA!.CANBSP',
                         comment="""  PNBSP_I :  NOMBRE DE SOUS_POINTS  """)


PCOMPOR = InputParameter(phys=PHY.COMPOR,
                         comment=""" POUR LES PMF""")


MASS_MECA_EXPLI = Option(
    para_in=(
        SP.PCACOQU,
        SP.PCADISM,
        SP.PCAGNBA,
        SP.PCAGNPO,
        PCAORIE,
        SP.PCINFDI,
        PCOMPOR,
        SP.PFIBRES,
        SP.PGEOMER,
        SP.PMATERC,
        PNBSP_I,
        PVARCPR,
    ),
    para_out=(
        SP.PMATUUR,
    ),
    condition=(
        CondCalcul('+', ((AT.PHENO, 'ME'), (AT.BORD, '0'),)),
    ),
    comment=""" matrice de masse "diagonale" adaptee a la commande DYNA_TRAN_EXPLI.

   L'option MASS_MECA_EXPLI a ete introduite en raison des ddls DRZ des
   elements de coque (DKT).
   Dans le repere local de l'element, la "masse" est theoriquement nulle.
   cela entraine souvent au niveau global, des frequences artificielles tres
   elevees et cela conduit a des pas de temps tres petits.

   Dans l'operateur DYNA_TRAN_EXPLI et pour les elements de coque (DKT),
   il a ete juge que :
     - la masse des ddls de rotation  etait presque negligeable par rapport
       a celle des ddls de translation
     - on peut, en consequence, systematiquement affceter sur les ddls DRZ :
       masse(DRZ) = 1/2*(masse(DRX)+masse(DRY))

   Pour les elements qui ne sont pas concernes par le ddl fictif DRZ, l'option
   MASS_MECA_EXPLI est la meme que MASS_MECA_DIAG.
""",
)
