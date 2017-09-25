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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    3 : _(u"""

 Le résidu global converge plus vite que la condition des contraintes planes.
 La convergence de la condition des contraintes planes peut être améliorée en
 augmentant ITER_CPLAN_MAXI (=1 par défaut), sous le mot-clé facteur COMPORTEMENT.

"""),

    27 : _(u"""
 La prédiction par DEPL_CALCULE à l'instant de calcul %(r1)f à partir du concept %(k1)s n'a pas pu être construite.
 Explications possibles :
  - le concept ne contient pas de champs de déplacement
  - l'instant de calcul demandé est en dehors de l'intervalle des instants calculés dans le concept fourni (il n'y a pas de prolongement à gauche ni à droite)

 Conseil :
 - vérifiez que le concept fourni sous le mot-clé EVOL_NOLI contient suffisamment d'instants pour interpoler le champ souhaité
"""),

    28 : _(u"""
 La prédiction par DEPL_CALCULE à l'instant de calcul %(r1)f à partir du concept %(k1)s n'a pas pu être construite car les maillages sont différents et vous utilisez des conditions limites de type Lagrange (AFFE_CHAR_MECA).
 Conseil : essayez avec des conditions limites de type AFFE_CHAR_CINE si c'est possible. Mais dans ce cas, le champ de déplacements n'étant plus cinématiquement admissible au premier pas de temps, vous risquez d'avoir des problèmes de convergence.
"""),

    37 : _(u"""
    ARRET=NON donc poursuite du calcul sans avoir eu convergence.
"""),

    38 : _(u"""
    DEFI_CONTACT/ALGO_CONT=PENALISATION/ADAPTATION=ADAPT_COEF ou TOUT. On n'arrive pas à adapter le coefficient de pénalisation de sorte à satisfaire le critère de pénétration maximum. Le rapport entre la pénétration maximale calculée et  la plus petite arête 
    dans la zone de contact maître est :  %(r1).2e.  
    
    Conseils :
    - Soit changer de mode adaptatif de pénalisation : DEFI_CONTACT/ALGO_CONT=PENALISATION/ADAPTATION=NON avec COEF_PENA_CONT <= %(r3).2e
    - Soit diminuer le pas de temps. 
    - Soit décider de continuer le calcul en relançant votre calcul avec PENE_MAXI en fonction du maillage dans la zone de contact.  Pour information : 
        - La plus petite arête de toutes les zones maîtres est  %(r2).2e.
        - La plus grande arête de toutes les zones maîtres est  %(r4).2e.
    
"""),

    39 : _(u"""
    DEFI_CONTACT/ALGO_CONT=PENALISATION/ADAPTATION=ADAPT_COEF ou TOUT. Il est possible que vous demandez un critère trop sévère pour la pénétration. La valeur de coefficient de pénalisation adaptée prend des valeurs inattendues.  
    
    Conseils :
    - Soit changer de mode adaptatif de pénalisation : DEFI_CONTACT/ALGO_CONT=PENALISATION/ADAPTATION=NON avec COEF_PENA_CONT <= %(r3).2e
    - Soit relancer votre calcul avec PENE_MAXI en fonction du maillage dans la zone de contact.  Pour information : 
        - La plus petite arête de toutes les zones maîtres est  %(r2).2e.
        - La plus grande arête de toutes les zones maîtres  %(r4).2e.
    
"""),

    67 : _(u"""
 Le code %(i1)d retourné lors de l'intégration de la loi de comportement n'est pas traité.
"""),

    93 : _(u"""
  -> Risque et conseils : dans le cas d'une résolution incrémentale, on ne prend pas en compte
     les éventuelles contraintes incompatibles dues à ces variables de commande initiales.
     Pour tenir compte de ces contraintes vous pouvez :
     - partir d'un instant fictif antérieur où toutes les variables de commande sont nulles 
       (ou égales aux valeurs de référence)
     - choisir des valeurs de référence adaptées

     Pour plus d'informations, consultez la documentation de AFFE_MATERIAU  
     (mot-clé AFFE_VARC).
"""),

    94 : _(u"""
  -> Indications supplémentaires : pour la variable de commande :  %(k1)s
     et la composante :  %(k2)s
     Valeur maximum : %(r1)f sur la maille : %(k3)s
     Valeur minimum : %(r2)f sur la maille : %(k4)s
"""),

    95 : _(u"""
  -> Indications supplémentaires : pour la variable de commande :  %(k1)s
     et la composante :  %(k2)s
     Valeur maximum de la valeur absolue de ( %(k2)s - %(k5)s_REF) : %(r1)f sur la maille : %(k3)s
     Valeur minimum de la valeur absolue de ( %(k2)s - %(k5)s_REF) : %(r2)f sur la maille : %(k4)s
"""),

    96 : _(u"""
 Le résidu RESI_COMP_RELA est inutilisable au premier instant de calcul (pas de référence)
 On bascule automatiquement en RESI_GLOB_RELA.
"""),

    97 : _(u"""
  -> A l'état initial (avant le premier instant de calcul) les variables 
     de commande (température, hydratation, séchage...) entraînent une 
     déformation anélastique non nulle.
     Cette déformation non nulle est incohérente avec l'état initial "vierge" qui est
     utilisé.
"""),

    98 : _(u"""
  -> Les forces extérieures (chargement imposé et réactions d'appui) sont détectées comme quasiment nulles (%(r1)g).
     Or vous avez demandé une convergence avec le critère relatif (RESI_GLOB_RELA).
     Pour éviter une division par zéro, le code est passé automatiquement en mode de convergence
     de type absolu (RESI_GLOB_MAXI).
     On a choisi un RESI_GLOB_MAXI de manière automatique et de valeur %(r2)g.
  -> Risque & Conseil : Vérifier bien que votre chargement doit être nul (ainsi que les réactions d'appui) à cet instant
     Dans le cas des problèmes de type THM, penser à utiliser éventuellement un
     critère de type référence (RESI_REFE_RELA).
"""),

}
