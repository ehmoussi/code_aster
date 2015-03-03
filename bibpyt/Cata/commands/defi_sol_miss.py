# coding=utf-8

from Cata.Descriptor import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: mathieu.courtois at edf.fr


DEFI_SOL_MISS = MACRO(nom="DEFI_SOL_MISS",
                      op=OPS('Macro.defi_sol_miss_ops.defi_sol_miss_ops'),
                      sd_prod=table_sdaster,
                      fr=tr("Définition des données de sol pour Miss"),
                      reentrant='n',
                      UIinfo={"groupes":("Modélisation","Outils-métier",)},
   MATERIAU = FACT(statut='o', max='**',
            fr=tr("Définition des matériaux"),
      E         = SIMP(statut='o', typ='R', fr=tr("Module d'Young")),
      NU        = SIMP(statut='o', typ='R', fr=tr("Coefficient de Poisson")),
      RHO       = SIMP(statut='o', typ='R', fr=tr("Masse volumique")),
      AMOR_HYST = SIMP(statut='o', typ='R', fr=tr("Coefficient d'amortissement")),
   ),
   COUCHE = FACT(statut='o', max='**',
                 fr=tr("Définition des couches"),
      regles=(AU_MOINS_UN('EPAIS','SUBSTRATUM'),),
      SUBSTRATUM= SIMP(statut='f', typ='TXM', into=("OUI","NON"),),
      EPAIS     = SIMP(statut='f', typ='R', fr=tr("Epaisseur de la couche")),
      RECEPTEUR = SIMP(statut='f', typ='TXM', defaut="NON", into=("OUI", "NON"),),
      SOURCE    = SIMP(statut='f', typ='TXM', defaut="NON", into=("OUI", "NON"),),
      NUME_MATE = SIMP(statut='o', typ='I', fr=tr("Numéro du matériau")),
   ),
   TITRE = SIMP(statut='f', typ='TXM', max='**',
                fr=tr("Titre de la table produite")),
   INFO  = SIMP(statut='f', typ='I', defaut=1, into=(1,2)),
)
