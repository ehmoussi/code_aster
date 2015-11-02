
# ======================================================================
# COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================

from cataelem.Tools.base_objects import InputParameter, OutputParameter, Option, CondCalcul
import cataelem.Commons.physical_quantities as PHY
import cataelem.Commons.parameters as SP




EFGE_EXCENT = Option(
    para_in=(
        SP.PCACOQU,
        SP.PEFFOGC,
        SP.PEFFOGR,
        SP.PEFFONC,
        SP.PEFFONR,
    ),
    para_out=(
        SP.PEFFOEGC,
        SP.PEFFOEGR,
        SP.PEFFOENC,
        SP.PEFFOENR,
    ),
    condition=(
      CondCalcul('+', (('PHENO','ME'),('EFGE','OUI'),('BORD','0'),)),
    ),
    comment="""  EFGE_EXCENT : CALCUL DES EFFORTS GENERALISES
           DANS LE "PLAN" MOYEN DES ELEMENTS DE COQUES EXCENTREES """,
)
