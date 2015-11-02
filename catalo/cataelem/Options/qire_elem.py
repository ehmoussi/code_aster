
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




PVOISIN  = InputParameter(phys=PHY.VOISIN,
comment="""  PVOISIN : VOISINS DE L ELEMENT """)


PERREUR  = OutputParameter(phys=PHY.ERRE_R, type='ELEM',
comment="""  PERREUR : ESTIMATEUR D ERREUR  """)


QIRE_ELEM = Option(
    para_in=(
        SP.PCONSTR,
        SP.PCONTNOD,
        SP.PCONTNOP,
        SP.PFFVOLUD,
        SP.PFFVOLUP,
        SP.PFORCED,
        SP.PFORCEP,
        SP.PFRVOLUD,
        SP.PFRVOLUP,
        SP.PGEOMER,
        SP.PPESANRD,
        SP.PPESANRP,
        SP.PPRESSD,
        SP.PPRESSP,
        SP.PROTATRD,
        SP.PROTATRP,
        SP.PTEMPSR,
           PVOISIN,
    ),
    para_out=(
           PERREUR,
    ),
    condition=(
      CondCalcul('+', (('PHENO','ME'),('BORD','0'),)),
    ),
    comment="""  QIRE_ELEM :
           ESTIMATEUR D ERREUR EN QUANTITE D INTERET
           PRODUIT UN CHAMP PAR ELEMENT  """,
)
