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
# person_in_charge: mathieu.courtois at edf.fr
def calc_fonction_prod(self, DERIVE, EXTRACTION, INTEGRE, INVERSE, COMB, COMB_C, MULT,
                       ENVELOPPE, FRACTILE, SPEC_OSCI, ASSE, FFT, COMPOSE, CORR_ACCE,
                       PUISSANCE, LISS_ENVELOP, ABS, REGR_POLYNOMIALE, DSP, **args):

   if (INTEGRE     != None): return fonction_sdaster
   if (DERIVE      != None): return fonction_sdaster
   if (INVERSE     != None): return fonction_sdaster
   if (COMB        != None):
      type_vale=AsType(COMB[0]['FONCTION'])
      for mcfact in COMB :
          if(AsType(mcfact['FONCTION'])!=type_vale):
             raise AsException("CALC_FONCTION/COMB : pas de types hétérogènes nappe/fonction")
      return type_vale
   if (COMB_C      != None):
      vale=COMB_C[0]['FONCTION']
      if(AsType(vale) == nappe_sdaster):
         for mcfact in COMB_C[1:] :
             if(AsType(mcfact['FONCTION'])!=nappe_sdaster):
                raise AsException("CALC_FONCTION/COMB_C : pas de types hétérogènes nappe/fonction")
         return nappe_sdaster
      else:
         for mcfact in COMB_C :
             if(AsType(mcfact['FONCTION'])==nappe_sdaster):
                raise AsException("CALC_FONCTION/COMB_C : pas de types hétérogènes nappe/fonction")
         return fonction_c
   if (ENVELOPPE   != None): return AsType(ENVELOPPE[0]['FONCTION'])
   if (FRACTILE    != None): return AsType(FRACTILE[0] ['FONCTION'])
   if (EXTRACTION  != None): return fonction_sdaster
   if (SPEC_OSCI   != None): return nappe_sdaster
   if (DSP         != None): return fonction_sdaster
   if (COMPOSE     != None): return fonction_sdaster
   if (ASSE        != None): return fonction_sdaster
   if (MULT        != None):
      type_vale = AsType(MULT[0]['FONCTION'])
      for mcfact in MULT:
          if(AsType(mcfact['FONCTION']) != type_vale):
             raise AsException("CALC_FONCTION/MULT : pas de types hétérogènes nappe/fonction")
      return type_vale
   if (FFT         != None):
      vale=FFT[0]['FONCTION']
      if (AsType(vale) == fonction_sdaster )  : return fonction_c
      if (AsType(vale) == fonction_c) : return fonction_sdaster
   if (CORR_ACCE   != None): return fonction_sdaster
   if (LISS_ENVELOP!= None): return nappe_sdaster
   if (REGR_POLYNOMIALE != None): return fonction_sdaster
   if (PUISSANCE   != None): return AsType(PUISSANCE[0]['FONCTION'])
   if (ABS         != None): return fonction_sdaster
   raise AsException("type de concept resultat non prevu")


CALC_FONCTION=MACRO(nom="CALC_FONCTION",
                    op=OPS('Macro.calc_fonction_ops.calc_fonction_ops'),
                    sd_prod=calc_fonction_prod,
                    fr=tr("Effectue des opérations mathématiques sur des concepts de type fonction"),
                    reentrant='n',
                    UIinfo={"groupes":("Fonctions",)},
         regles=(UN_PARMI('DERIVE', 'INTEGRE', 'SPEC_OSCI', 'DSP', 'FFT', 'CORR_ACCE',
                          'COMB', 'COMB_C', 'MULT', 'ASSE', 'INVERSE', 'ABS',
                          'ENVELOPPE', 'COMPOSE', 'EXTRACTION', 'PUISSANCE', 
                          'LISS_ENVELOP', 'FRACTILE', 'REGR_POLYNOMIALE'),),
         FFT             =FACT(statut='f',fr=tr("Transformée de Fourier ou de son inverse"),
           FONCTION        =SIMP(statut='o',typ=(fonction_sdaster,fonction_c) ),
           METHODE         =SIMP(statut='f',typ='TXM',defaut="PROL_ZERO",into=("PROL_ZERO","TRONCATURE","COMPLET") ),
           b_syme          =BLOC ( condition = " AsType(FONCTION)==fonction_c ",
             SYME           =SIMP(statut='f',typ='TXM',into=('OUI','NON'),defaut='OUI' ),
           ),
         ),
         DERIVE          =FACT(statut='f',fr=tr("Dérivée d une fonction"),
           METHODE         =SIMP(statut='f',typ='TXM',defaut="DIFF_CENTREE",into=("DIFF_CENTREE",) ),
           FONCTION        =SIMP(statut='o',typ=fonction_sdaster ),
         ),
         INTEGRE         =FACT(statut='f',fr=tr("Intégrale d'une fonction"),
           METHODE         =SIMP(statut='f',typ='TXM',defaut="TRAPEZE",into=("SIMPSON","TRAPEZE") ),
           FONCTION        =SIMP(statut='o',typ=fonction_sdaster),
           COEF            =SIMP(statut='f',typ='R',defaut= 0.E+0,fr=tr("Valeur de la constante d intégration") ),
         ),
         LISS_ENVELOP    = FACT(statut='f',fr=tr("Lissage d une enveloppe"),
           NAPPE           =SIMP(statut='o',typ=nappe_sdaster ),
           FREQ_MIN        =SIMP(statut='f',typ='R',defaut =0.2),
           FREQ_MAX        =SIMP(statut='f',typ='R',defaut =35.5),
           ELARG           =SIMP(statut='f',typ='R',defaut =0.1 ),
           TOLE_LISS       =SIMP(statut='f',typ='R',defaut =0.25 ),
         ),
         REGR_POLYNOMIALE = FACT(statut='f',fr=tr("Régression polynomiale d'une fonction"),
           FONCTION        =SIMP(statut='o',typ=fonction_sdaster),
           DEGRE           =SIMP(statut='o',typ='I'),
         ),
        SPEC_OSCI       =FACT(statut='f',fr=tr("Spectre d'oscillateur"),
           METHODE         =SIMP(statut='f',typ='TXM',defaut="NIGAM",into=("NIGAM","HARMO","RICE") ),
           FONCTION        =SIMP(statut='o',typ=fonction_sdaster ),
           AMOR_REDUIT     =SIMP(statut='f',typ='R',max='**'),
           LIST_FREQ       =SIMP(statut='f',typ=listr8_sdaster ),
           FREQ            =SIMP(statut='f',typ='R',  max='**'),
           NORME           =SIMP(statut='o',typ='R',fr=tr("Valeur de la norme du spectre d oscillateur") ),
           NATURE          =SIMP(statut='f',typ='TXM',defaut="ACCE",into=("DEPL","VITE","ACCE") ),
           b_methode       =BLOC(condition = "METHODE !='RICE' ",
             NATURE_FONC     =SIMP(statut='f', typ='TXM', defaut="ACCE", into=("ACCE",),),),
           b_rice          =BLOC(condition = "METHODE =='RICE' ",
             DUREE           =SIMP(statut='o', typ='R', val_min=0.,
                                 fr=tr("durée de la phase forte pour facteur de pic")),
             NATURE_FONC     =SIMP(statut='f', typ='TXM', defaut="DSP", into=("DSP",),),),
         ),
         DSP             =FACT(statut='f', fr=tr("Densité spectrale"),
           FONCTION        =SIMP(statut='o', typ=fonction_sdaster ),
           AMOR_REDUIT     =SIMP(statut='o', typ='R', val_min=0., val_max=1.),
           NORME           =SIMP(statut='o', typ='R'),
           LIST_FREQ       =SIMP(statut='f', typ=listr8_sdaster ),
           FREQ_PAS            =SIMP(statut='f', typ='R'),
                regles=(UN_PARMI('FREQ_PAS','LIST_FREQ'),),
           FREQ_COUP       =SIMP(statut='o', typ='R', fr=tr("fréquence de coupure") ),
           DUREE           =SIMP(statut='o', typ='R', val_min=0.,
                                 fr=tr("durée de la phase forte pour facteur de peak")),
           FRACT           =SIMP(statut='o', typ='R', defaut=0.5, val_min=0., val_max=1., fr=tr("fractile") ),
         ),
         ABS             =FACT(statut='f',fr=tr("Valeur absolue d'une fonction"),
           FONCTION        =SIMP(statut='o',typ=fonction_sdaster,),
         ),
         COMB            =FACT(statut='f',max='**',fr=tr("Combinaison linéaire réelle de fonctions"),
           FONCTION        =SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster) ),
           COEF            =SIMP(statut='o',typ='R',fr=tr("Coefficient réel de la combinaison linéaire associée à la fonction") ),
         ),
         COMB_C          =FACT(statut='f',max='**',fr=tr("Combinaison linéaire complexe de fonctions"),
           regles=(UN_PARMI('COEF_R','COEF_C'),),
           FONCTION        =SIMP(statut='o',typ=(fonction_sdaster,fonction_c,nappe_sdaster) ),
           COEF_R          =SIMP(statut='f',typ='R',fr=tr("Coefficient réel de la combinaison linéaire associée à la fonction") ),
           COEF_C          =SIMP(statut='f',typ='C',fr=tr("Coefficient complexe de la combinaison linéaire associée à la fonction") ),
         ),
         MULT            =FACT(statut='f',max='**',fr=tr("Produit de fonctions réelles"),
           FONCTION        =SIMP(statut='o',typ=(fonction_sdaster,fonction_c,nappe_sdaster) ),
         ),
         b_comb          =BLOC ( condition = "COMB != None or COMB_C != None " \
                                             "or REGR_POLYNOMIALE != None or MULT != None",
             LIST_PARA      =SIMP(statut='f',typ=listr8_sdaster ),
         ),
         COMPOSE         =FACT(statut='f',fr=tr("Composition de deux fonctions FONC_RESU(FONC_PARA)"),
           FONC_RESU       =SIMP(statut='o',typ=fonction_sdaster),
           FONC_PARA       =SIMP(statut='o',typ=fonction_sdaster),
         ),
         EXTRACTION      =FACT(statut='f',fr=tr("Extraction sur une fonction complexe"),
           FONCTION        =SIMP(statut='o',typ=fonction_c),
           PARTIE          =SIMP(statut='o',typ='TXM',into=("REEL","IMAG","MODULE","PHASE"),fr=tr("Partie à extraire")),
         ),
         ENVELOPPE       =FACT(statut='f',fr=tr("Enveloppe d une famille de fonctions"),
           FONCTION        =SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster),max='**' ),
           CRITERE         =SIMP(statut='f',typ='TXM',defaut="SUP",into=("SUP","INF"),fr=tr("Type de l enveloppe") ),
         ),
         FRACTILE        =FACT(statut='f',fr=tr("Fractile d une famille de fonctions ou de nappes"),
           FONCTION        =SIMP(statut='o',typ=(fonction_sdaster,nappe_sdaster),max='**' ),
           FRACT           =SIMP(statut='o',typ='R',defaut=1.,val_min=0.,val_max=1.,fr=tr("Valeur du fractile") ),
         ),
         ASSE            =FACT(statut='f',fr=tr("Concatenation de fonctions"),
           FONCTION        =SIMP(statut='o',typ=fonction_sdaster,min=2,max=2 ),
           SURCHARGE       =SIMP(statut='f',typ='TXM',defaut="DROITE",into=("DROITE","GAUCHE")),
         ),
         CORR_ACCE       =FACT(statut='f',fr=tr("Correction d un accelerogramme reel"),
            FONCTION        =SIMP(statut='o',typ=fonction_sdaster ),
            METHODE         =SIMP(statut='o',typ='TXM',into=("FILTRAGE","POLYNOME",) ),
            b_corr1          =BLOC ( condition = "METHODE== 'FILTRAGE' ",
                FREQ_FILTRE  =SIMP(statut='f',typ='R', defaut= 0.05, val_min=0.0, fr=tr("frequence du filtre temporel") ),),
            b_corr2          =BLOC ( condition = "METHODE== 'POLYNOME' ",
                CORR_DEPL       =SIMP(statut='f',typ='TXM',defaut="NON",into=("OUI","NON")),),
         ),
         PUISSANCE       =FACT(statut='f',fr=tr("Fonction élevée à une puissance"),
            FONCTION      =SIMP(statut='o', typ=(fonction_sdaster,nappe_sdaster) ),
            EXPOSANT      =SIMP(statut='f', typ='I', defaut=1 ),
         ),
         INVERSE         =FACT(statut='f',fr=tr("Inverse d'une fonction"),
            FONCTION      =SIMP(statut='o', typ=fonction_sdaster),
         ),
         NOM_PARA        =SIMP(statut='f',typ='TXM',into=C_PARA_FONCTION() ),
         NOM_RESU        =SIMP(statut='f',typ='TXM' ),
         INTERPOL        =SIMP(statut='f',typ='TXM',max=2,into=("NON","LIN","LOG"),
                               fr=tr("Type d'interpolation pour les abscisses et les ordonnées de la " \
                                    "fonction ou bien pour le paramètre de la nappe.")),
         PROL_DROITE     =SIMP(statut='f',typ='TXM',into=("CONSTANT","LINEAIRE","EXCLU") ),
         PROL_GAUCHE     =SIMP(statut='f',typ='TXM',into=("CONSTANT","LINEAIRE","EXCLU") ),
         NOM_PARA_FONC   =SIMP(statut='f',typ='TXM',into=C_PARA_FONCTION() ),
         INTERPOL_FONC   =SIMP(statut='f',typ='TXM',max=2,into=("NON","LIN","LOG"),
                                 fr=tr("Type d'interpolation pour les abscisses et les ordonnées de la fonction")),
         PROL_DROITE_FONC=SIMP(statut='f',typ='TXM',into=("CONSTANT","LINEAIRE","EXCLU") ),
         PROL_GAUCHE_FONC=SIMP(statut='f',typ='TXM',into=("CONSTANT","LINEAIRE","EXCLU") ),
         INFO            =SIMP(statut='f',typ='I',defaut=1,into=(1,2) ),
)
