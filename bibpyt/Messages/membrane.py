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
    
    1 : _(u"""

      Vous avez indiqué une épaisseur nulle ou négative (inférieure à la précision des nombres réels). 
      Renseignez une valeur positive non nulle. 

"""),
   
    2 : _(u"""

      Vous utilisez un élément MEMBRANE avec STAT_NON_LINE.
      Problème : Les membranes ne prennent pas en compte le COMPORTEMENT %(k1)s .
      Solution : Si vous faites l'hypothèse des petites perturbations (valeur par défaut), indiquez
                 COMPORTEMENT=PETIT. Si vous êtes en grandes déformations utilisez COMPORTEMENT=GROT_GDEP.

"""),
    
        3 : _(u"""

      Vous utilisez un élément MEMBRANE en GROT_GDEP.
      Problème : Les membranes en non linéaire ne fonctionnent qu'avec le choix ELAS_MEMBRANE_SV ou
                 ELAS_MEMBRANE_NH sous le mot clé RELATION de COMPORTEMENT.
      Solution : Changez votre choix de COMPORTEMENT.

"""),
        4 : _(u"""

      Vous utilisez un élément MEMBRANE en GROT_GDEP  avec ELAS_MEMBRANE_SV ou ELAS_MEMBRANE_NH.
      Problème : En membrane hyper-élastique, seuls le module d'Young et le coefficient de poisson sont nécessaires.
      Solution : Dans DEFI_MATERIAU choisissez le comportement ELAS.

"""),
        5 : _(u"""

      Vous utilisez un élément MEMBRANE et essayez de calculer la matrice de rigidité élastique.
      Problème : Vous utilisez des mots clés incohérents.
      Solution : Plusieurs solutions peuvent être envisagées :
                 - Si vous utilisez des éléments MEMBRANE en petites déformations,il faut renseigner
                   le mot clé 'ELAS_MEMBRANE' dans DEFI_MATERIAU. 
                 - Si vous utilisez des éléments MEMBRANE en grandes déformations avec STAT_NON_LINE, il faut
                   renseigner MATRICE='TANGENTE' et non 'ELASTIQUE' sous le mot clé NEWTON dans la commande
                   STAT_NON_LINE.

"""),
        6 : _(u"""

      Vous utilisez un élément MEMBRANE en GROT_GDEP avec ELAS_MEMBRANE_SV ou ELAS_MEMBRANE_NH.
      Problème : Vous avez spécifié des angles dans ANGLE_REP.
      Avertissement : Ces angles ne servent pas à définir une anisotropie, leur seul 
                      rôle et de définir les directions d'affichage des contraintes

"""),
        7 : _(u"""

      Vous utilisez un élément MEMBRANE en GROT_GDEP avec ELAS_MEMBRANE_SV ou ELAS_MEMBRANE_NH.
      Problème : Vous avez spécifié une option de chargement non prise en compte.
      Solution : Modifiez vos chargements. 

"""),
        8 : _(u"""

      Vous voulez post-traiter un élément MEMBRANE en GROT_GDEP avec %(k1)s.
      Problème : Vous avez spécifié une option de post-traitement non prise en compte.
      Solution : Modifiez vos options de post-traitement. 

"""),
        9 : _(u"""

      Vous utilisez les membranes en GROT_GDEP en dynamique.
      Problème : La dynamique n'est pas implémentée pour les membranes en grandes déformations.
      SOLUTION : Faites un calcul en statique ou changez d'élément. 

"""),
        10 : _(u"""

      Vous utilisez un élément de MEMBRANE.
      Problème : Le comportement sélectionné n'est pas compatible avec le type de matériau.
      Solution : On rappel :
                 - en petites déformations, on utilise 'ELAS_MEMBRANE' sous DEFI_MATERIAU
                   et on utilise les options de calcul MECA_STATIQUE ,ou, STAT_NON_LINE avec
                   les mots clés COMPORTEMENT='PETIT' et RELATION='ELAS'.
                 - en grandes déformations, on utilise 'ELAS' sous DEFI_MATERIAU et on utilise
                   l'option de calcul STAT_NON_LINE avec les mots clés COMPORTEMENT='GROT_GDEP' 
                   et RELATION='ELAS_MEMBRANE_SV' ou 'ELAS_MEMBRANE_NH'.

"""),

}
