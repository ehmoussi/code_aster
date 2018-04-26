# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: j-pierre.lefebvre at edf.fr


from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *


def macr_ecla_pg_prod(self,RESULTAT,MAILLAGE,RESU_INIT,**args):
  if args.get('__all__'):
      return None

  self.type_sdprod(RESULTAT,AsType(RESU_INIT))
  self.type_sdprod(MAILLAGE,maillage_sdaster)
  return None


MACR_ECLA_PG=MACRO(nom="MACR_ECLA_PG",
                   op=OPS('Macro.macr_ecla_pg_ops.macr_ecla_pg_ops'),
                   sd_prod=macr_ecla_pg_prod,
                   reentrant='n',
                   fr=tr("Permettre la visualisation des champs aux points de Gauss d'une "
                        "SD_RESULTAT sans lissage ni interpolation"),

             # SD résultat ,modèle et champs à "éclater" :
             RESU_INIT       =SIMP(statut='o',typ=resultat_sdaster,fr=tr("RESULTAT à éclater"),),
             MODELE_INIT     =SIMP(statut='o',typ=modele_sdaster,fr=tr("MODELE à éclater")),
             NOM_CHAM        =SIMP(statut='o',typ='TXM',validators=NoRepeat(),max='**',into=C_NOM_CHAM_INTO('ELGA'),),

             # paramètres numériques de la commande :
             SHRINK          =SIMP(statut='f',typ='R',defaut= 0.9, fr=tr("Facteur de réduction") ),
             TAILLE_MIN      =SIMP(statut='f',typ='R',defaut= 0.0, fr=tr("Taille minimale d'un coté") ),

             # concepts produits par la commande :
             RESULTAT        =SIMP(statut='o',typ=CO,fr=tr("SD_RESULTAT résultat de la commande")),
             MAILLAGE        =SIMP(statut='o',typ=CO,fr=tr("MAILLAGE associé aux cham_no de la SD_RESULTAT")),

             # Sélection éventuelle d'un sous-ensemble des éléments à visualiser :
             TOUT            =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             MAILLE          =SIMP(statut='c',typ=ma  ,validators=NoRepeat(),max='**'),
             GROUP_MA        =SIMP(statut='f',typ=grma,validators=NoRepeat(),max='**'),

             # Sélection des numéros d'ordre :
             regles=(EXCLUS('TOUT_ORDRE','NUME_ORDRE','INST','LIST_INST','LIST_ORDRE'),),
             TOUT_ORDRE      =SIMP(statut='f',typ='TXM',into=("OUI",) ),
             NUME_ORDRE      =SIMP(statut='f',typ='I',validators=NoRepeat(),max='**'),
             LIST_ORDRE      =SIMP(statut='f',typ=listis_sdaster),
             INST            =SIMP(statut='f',typ='R',validators=NoRepeat(),max='**'),
             LIST_INST       =SIMP(statut='f',typ=listr8_sdaster),
             CRITERE         =SIMP(statut='f',typ='TXM',defaut="RELATIF",into=("RELATIF","ABSOLU",),),
             b_prec_rela=BLOC(condition="""(equal_to("CRITERE", 'RELATIF'))""",
                 PRECISION       =SIMP(statut='f',typ='R',defaut= 1.E-6,),),
             b_prec_abso=BLOC(condition="""(equal_to("CRITERE", 'ABSOLU'))""",
                 PRECISION       =SIMP(statut='o',typ='R',),),
            )
