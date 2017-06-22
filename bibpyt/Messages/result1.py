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
  Lors de la construction ou de la lecture d'un résultat non-linéaire, le champ des variables internes lu ou créé n'est pas cohérent avec le comportement donné par le mot-clef COMPORTEMENT.
"""),

    2 : _(u"""
Le paramètre <%(k2)s> n'est pas le même sur tous les numéros d'ordre dans la structure de données résultat de nom <%(k1)s>.
Ce n'est pas possible dans cet opérateur.
"""),

    3 : _(u"""
On ne trouve aucun numéro d'ordre dans la structure de données résultat de nom <%(k1)s>
"""),

    37: _(u"""
Le MODELE fourni par l'utilisateur est différent de celui présent dans la structure de données Résultat. 
On poursuit les calculs avec le MODELE fourni par l'utilisateur.

Risque & Conseil : Vérifiez si le MODELE fourni dans la commande est bien celui que vous souhaitez. 
Si oui, vous allez poursuivre les calculs de post-traitement avec un MODELE différent de
celui utilisé pour calculer les déplacements, températures,...
"""),

    38: _(u"""
Les caractéristiques élémentaires CARA_ELEM fournies par l'utilisateur sont différentes de celles présentes dans la structure de données Résultat.  
On poursuit les calculs avec le CARA_ELEM fourni par l'utilisateur.

Risque & Conseil : Vérifiez si le CARA_ELEM fourni dans la commande est bien celui que vous souhaitez. 
Si oui, vous allez poursuivre les calculs de post-traitement avec un CARA_ELEM différent de
celui utilisé pour calculer les déplacements, températures,...
"""),

    39: _(u"""
Le matériau fourni par l'utilisateur est différent de celui présent dans la structure de données Résultat. 
On poursuit les calculs avec le matériau fourni par l'utilisateur.

Risque & Conseil : Vérifiez si le matériau fourni dans la commande est bien celui que vous souhaitez. 
Si oui, vous allez poursuivre les calculs de post-traitement avec un matériau différent de 
celui utilisé pour calculer les déplacements, températures,...
"""),

    40: _(u"""
Le chargement fourni par l'utilisateur est différent de celui présent dans la 
structure de données Résultat. On poursuit les calculs avec le chargement fourni par l'utilisateur.

Risque & Conseil : Vérifiez si le chargement fourni dans la commande est bien celui que vous souhaitez. 
Si oui vous allez poursuivre les calculs post-traitement avec un chargement différent de celui utilisé 
pour calculer les déplacements, températures,...
"""),

    41: _(u"""
Les fonctions multiplicatrices du chargement (mot clé: FONC_MULT) fournies par l'utilisateur sont 
différentes de celles présentes dans la structure de données Résultat. On poursuit les calculs avec 
les fonctions multiplicatrices fournies par l'utilisateur.

Risque & Conseil : Vérifiez si les fonctions fournies dans la commande sont bien celles que vous souhaitez. 
Si oui vous allez poursuivre les calculs de post-traitement avec des fonctions différentes de celles 
utilisées pour calculer les déplacements, températures,...
"""),


    65: _(u"""
Vous avez fourni %(i1)d charges alors qu'il n'y a %(i2)d dans la structure de données Résultat.

Risque & Conseil :
   Vous pouvez obtenir des résultats faux si les charges sont différentes.
   Vérifiez que vous n'avez pas oublié de charge ou que vous n'en avez pas ajouté.
"""),

    66: _(u"""
Le couple (charge, fonction) fourni par l'utilisateur n'est pas présent dans la structure de données résultat.
On poursuit le calcul avec le chargement fourni par l'utilisateur.
   Charge   (utilisateur) : %(k1)s
   Fonction (utilisateur) : %(k2)s
   Charge   (résultat)    : %(k3)s
   Fonction (résultat)    : %(k4)s
"""),

}
