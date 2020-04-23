# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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




PCOMPOR  = InputParameter(phys=PHY.COMPOR,
comment="""  Informations for non-linear comportment """)


PCAORIE  = InputParameter(phys=PHY.CAORIE,
comment=""" ORIENTATION DES REPERES LOCAUX DES POUTRES ET TUYAUX """)


PCONTMR  = InputParameter(phys=PHY.SIEF_R,
comment=""" VECTEUR DES CONTRAINTES POUR T- """)


PVARIMR  = InputParameter(phys=PHY.VARI_R,
comment=""" VARIABLES INTERNES POUR T- """)


PVARCPR  = InputParameter(phys=PHY.VARI_R,
comment=""" VARIABLES DE COMMANDES  POUR T+ """)


PNBSP_I  = InputParameter(phys=PHY.NBSP_I,
comment=""" NOMBRE DE SOUS-POINTS (EPAISSEUR COQUES/TUYAUX) ET DE FIBRES (PMF) """)


PPINTTO  = InputParameter(phys=PHY.N132_R,
comment=""" XFEM - COORD. POINTS SOMMETS DES SOUS-ELEMENTS """)


PCNSETO  = InputParameter(phys=PHY.N1280I, container='MODL!.TOPOSE.CNS',
comment="""  XFEM - CONNECTIVITE DES SOUS-ELEMENTS  """)


PHEAVTO  = InputParameter(phys=PHY.N512_I,
comment=""" XFEM - VALEUR FONCTION HEAVISIDE SUR LES SOUS-ELEMENTS """)


PLONCHA  = InputParameter(phys=PHY.N120_I, container='MODL!.TOPOSE.LON',
comment="""  XFEM - NBRE DE TETRAEDRES ET DE SOUS-ELEMENTS  """)


PBASLOR  = InputParameter(phys=PHY.NEUT_R,
comment=""" XFEM - BASE LOCALE AU FOND DE FISSURE """)


PLSN     = InputParameter(phys=PHY.NEUT_R,
comment=""" XFEM - VALEURS DE LA LEVEL SET NORMALE """)


PLST     = InputParameter(phys=PHY.NEUT_R,
comment=""" XFEM - VALEURS DE LA LEVEL SET TANGENTE """)


PSTANO   = InputParameter(phys=PHY.N120_I,
comment=""" XFEM - STATUT DES NOEUDS (ENRICHISSEMENT) """)


PPMILTO  = InputParameter(phys=PHY.N792_R)


PFISNO   = InputParameter(phys=PHY.NEUT_I,
comment=""" PFISNO : CONNECTIVITE DES FISSURES ET DES DDL HEAVISIDE """)


PHEA_NO  = InputParameter(phys=PHY.N120_I)


PCONTPR  = OutputParameter(phys=PHY.SIEF_R, type='ELGA',
comment=""" VECTEUR DES CONTRAINTES POUR T+ """)


PVARIPR  = OutputParameter(phys=PHY.VARI_R, type='ELGA',
comment=""" VARIABLES INTERNES POUR T+ """)


PCACO3D  = OutputParameter(phys=PHY.CACO3D, type='ELEM',
comment=""" COQUE_3D (ROTATION FICTIVE AUTOUR DE LA NORMALE) """)

# For HHO
PCELLMR  = InputParameter(phys=PHY.CELL_R,
comment=""" HHO - degres de liberte de la cellule""")

PCELLIR  = InputParameter(phys=PHY.CELL_R,
comment=""" HHO - degres de liberte de la cellule""")

PCSMTIR  = OutputParameter(phys=PHY.N6480R, type='ELEM',
comment=""" HHO - matrice cellule pour condensation statique""")

PCSRTIR  = OutputParameter(phys=PHY.CELL_R, type='ELEM',
comment=""" HHO - 2nd membre cellule pour condensation statique""")

PCHHOGT  = InputParameter(phys=PHY.N6480R,
comment=""" HHO - matrice du gradient local""")

PCHHOST  = InputParameter(phys=PHY.N6480R,
comment=""" HHO - matrice de la stabilisation locale""")


FULL_MECA = Option(
    para_in=(
        SP.PACCKM1,
        SP.PACCPLU,
           PBASLOR,
        SP.PCACABL,
        SP.PCACOQU,
        SP.PCADISK,
        SP.PCAGEPO,
        SP.PCAGNBA,
        SP.PCAGNPO,
        SP.PCAARPO,
        SP.PCAMASS,
           PCAORIE,
        SP.PCARCRI,
        SP.PCINFDI,
           PCNSETO,
           PCOMPOR,
        SP.PMULCOM,
           PCONTMR,
        SP.PDDEPLA,
        SP.PDEPENT,
        SP.PDEPKM1,
        SP.PDEPLMR,
        SP.PDEPLPR,
        SP.PFIBRES,
           PFISNO,
        SP.PGEOMER,
        SP.PHEAVNO,
           PHEAVTO,
           PHEA_NO,
        SP.PINSTMR,
        SP.PINSTPR,
        SP.PITERAT,
           PLONCHA,
           PLSN,
           PLST,
        SP.PMATERC,
           PNBSP_I,
           PPINTTO,
           PPMILTO,
        SP.PROMK,
        SP.PROMKM1,
        SP.PSTADYN,
           PSTANO,
        SP.PSTRXMP,
        SP.PSTRXMR,
        SP.PVARCMR,
           PVARCPR,
        SP.PVARCRR,
        SP.PVARIMP,
           PVARIMR,
        SP.PVITENT,
        SP.PVITKM1,
        SP.PVITPLU,
           PCELLMR,
           PCELLIR,
           PCHHOGT,
           PCHHOST,
    ),
    para_out=(
           PCACO3D,
        SP.PCODRET,
           PCONTPR,
        SP.PMATUNS,
        SP.PMATUUR,
        SP.PSTRXPR,
           PVARIPR,
        SP.PVECTUR,
           PCSMTIR,
           PCSRTIR,
    ),
    condition=(
      CondCalcul('+', ((AT.PHENO,'ME'),(AT.BORD,'0'),)),
      CondCalcul('-', ((AT.FLUIDE,'OUI'),(AT.ABSO,'OUI'),)),
      CondCalcul('-', ((AT.PHENO,'ME'),(AT.FSI ,'OUI'),)),
    ),
    comment=""" MATRICE TANGENTE COHERENTE POUR MECANIQUE NON-LINEAIRE """,
)
