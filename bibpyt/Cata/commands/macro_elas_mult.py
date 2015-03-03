# coding=utf-8

from Cata.Descriptor import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: xavier.desroches at edf.fr


def macro_elas_mult_prod(self,NUME_DDL,CAS_CHARGE,**args ):
  if NUME_DDL is not None and NUME_DDL.is_typco():
    self.type_sdprod(NUME_DDL,nume_ddl_sdaster)
  if CAS_CHARGE[0]['NOM_CAS']      != None : return mult_elas
  if CAS_CHARGE[0]['MODE_FOURIER'] != None : return fourier_elas
  raise AsException("type de concept resultat non prevu")

MACRO_ELAS_MULT=MACRO(nom="MACRO_ELAS_MULT",
                      op=OPS('Macro.macro_elas_mult_ops.macro_elas_mult_ops'),
                      sd_prod=macro_elas_mult_prod,
                      reentrant='f',
                      UIinfo={"groupes":("Résolution",)},
                      fr=tr("Calculer les réponses statiques linéaires pour différents cas "
                           "de charges ou modes de Fourier"),
         regles=(UN_PARMI('CHAR_MECA_GLOBAL','LIAISON_DISCRET', ),),
         MODELE          =SIMP(statut='o',typ=modele_sdaster),
         CHAM_MATER      =SIMP(statut='f',typ=cham_mater),
         CARA_ELEM       =SIMP(statut='f',typ=cara_elem),
         NUME_DDL        =SIMP(statut='f',typ=(nume_ddl_sdaster,CO)),
         CHAR_MECA_GLOBAL=SIMP(statut='f',typ=(char_meca),validators=NoRepeat(),max='**'),
         LIAISON_DISCRET =SIMP(statut='f',typ='TXM',into=("OUI",)),
         CAS_CHARGE      =FACT(statut='o',max='**',
           regles=(UN_PARMI('NOM_CAS','MODE_FOURIER'),
                   UN_PARMI('CHAR_MECA','VECT_ASSE'),),
           NOM_CAS         =SIMP(statut='f',typ='TXM' ),
           MODE_FOURIER    =SIMP(statut='f',typ='I' ),
           TYPE_MODE       =SIMP(statut='f',typ='TXM',defaut="SYME",into=("SYME","ANTI","TOUS") ),
           CHAR_MECA       =SIMP(statut='f',typ=(char_meca),validators=NoRepeat(),max='**'),
           OPTION          =SIMP(statut='f',typ='TXM',into=("SIEF_ELGA","SANS"),defaut="SIEF_ELGA",max=1,
                                 fr=tr("Contraintes aux points de Gauss."),),
           SOUS_TITRE      =SIMP(statut='f',typ='TXM',max='**'),
           VECT_ASSE       =SIMP(statut='f',typ=cham_no_sdaster),
         ),
         SOLVEUR         =FACT(statut='d',
           METHODE         =SIMP(statut='f',typ='TXM',defaut="MULT_FRONT",into=("MULT_FRONT","LDLT") ),
           b_mult_front    = BLOC ( condition = "METHODE == 'MULT_FRONT' ",
                                    fr=tr("Paramètres de la méthode multi frontale"),
             RENUM           =SIMP(statut='f',typ='TXM',defaut="METIS",into=("MD","MDA","METIS") ),
           ),
           b_ldlt          =BLOC(condition = "METHODE == 'LDLT' ",fr=tr("Paramètres de la méthode LDLT"),
             RENUM           =SIMP(statut='f',typ='TXM',defaut="RCMK",into=("RCMK","SANS") ),
            ),
           b_ldlt_mult     =BLOC(condition = "METHODE == 'LDLT' or METHODE == 'MULT_FRONT' ",
                                   fr=tr("Paramètres relatifs à la non inversibilité de la matrice à factorise"),
             NPREC           =SIMP(statut='f',typ='I',defaut= 8 ),
             STOP_SINGULIER  =SIMP(statut='f',typ='TXM',defaut="OUI",into=("OUI","NON") ),
           ),
         ),
         INFO            =SIMP(statut='f',typ='I',defaut= 1,into=(1,2)),
         TITRE           =SIMP(statut='f',typ='TXM',max='**'),
)  ;
