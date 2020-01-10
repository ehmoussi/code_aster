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

from code_aster.Utilities import _

cata_msg = {

    1 : _("""
Erreur utilisateur dans la commande CREA_RESU / AFFE :
 Le maillage associé au mot clé CHAM_GD           : %(k1)s
 est différent de celui associé au mot clé MODELE : %(k2)s
"""),

    2 : _("""
 L'état initial défini n'est pas plastiquement admissible pour le modèle LETK.
 L'état initial de contraintes est erroné ou les propriétés matériaux ne sont pas adaptées au problème posé.
 Le calcul s'arrête en erreur fatale par précautions.
"""),

    3 : _("""
 REPERE='COQUE' ne traite que les champs aux éléments, pas les champs aux noeuds.
 On arrête le calcul.
"""),

    4 : _("""
 Le repère utilisateur défini par VECT_X et VECT_Y ne peut être utilisé qu'en 3D.
"""),

    6 : _("""
 il faut définir NOM_CMP
"""),

    7 : _("""
 Il faut définir 3 angles nautiques.
"""),

    8 : _("""
 L'origine doit être définie par 3 coordonnées.
"""),

    9 : _("""
 L'axe z est obligatoire en 3D.
"""),

    10 : _("""
 En 2D, seules les premières 2 coordonnées sont considérées pour l'origine.
"""),

    11 : _("""
 L'axe z n'a pas de sens en 2D. Le mot-clé AXE_Z est inutile.
"""),

    13 : _("""
  -> Lors du passage au repère cylindrique, un noeud a été localisé sur l'axe
     du repère cylindrique. Code_Aster utilise dans ce cas le centre de gravité de
     l'élément pour le calcul de la matrice de passage en repère cylindrique.
  -> Risque & Conseil :
     Si ce centre de gravité se trouve également sur l'axe du repère, le calcul
     s'arrête en erreur fatale.
"""),


    15 : _("""
 les modélisations autorisées sont 3D et D_PLAN et AXIS
"""),

    16 : _("""
 le choix des paramètres ne correspond pas à l'un des modèles CJS
"""),

    17 : _("""
 la loi CJS ne converge pas
"""),

    18 : _("""
 la loi CJS ne converge pas avec le nombre maximal d'itérations (intégration locale)
"""),

    20 : _("""
 modélisation inconnue
"""),

    22 : _("""
 vecteur de norme nulle
"""),

    23 : _("""
 Le type de maille %(k1)s n'est pas prévu.
"""),

    24 : _("""
 la maille doit être de type TETRA4, TETRA10, PENTA6, PENTA15, HEXA8 ou HEXA20.
 ou TRIA3-6 ou QUAD4-8
 or la maille est de type :  %(k1)s .
"""),

    26 : _("""
  %(k1)s  groupe inexistant
"""),

    27 : _("""
 La maille  %(k1)s  de type  %(k2)s  est invalide pour ORIE_FISSURE.
"""),

    28 : _("""
 Le groupe de mailles pour ORIE_FISSURE est invalide.
"""),

    29 : _("""
 Dans le groupe à réorienter pour ORIE_FISSURE,
 Il existe des mailles 2d et 3d.
 C'est interdit.
"""),

    30 : _("""
Erreur d'utilisation pour MODI_MAILLAGE / ORIE_FISSURE :
  On ne peut pas orienter les mailles.

Risques & conseils :
  Les mailles à orienter doivent correspondre à une mono couche d'éléments (2D ou 3D).
  Ces éléments doivent s'appuyer sur d'autres éléments de même dimension (2D ou 3D)
  pour pouvoir déterminer la direction transverse à la couche.
  Consulter la documentation d'utilisation pour plus de détails.
"""),










    43 : _("""
 pas de calcul sur le critère de Rice disponible
"""),

    44 : _("""
 cette commande doit nécessairement avoir le type EVOL_THER.
"""),

    45 : _("""
 seuls les champs de fonctions aux noeuds sont évaluables:  %(k1)s
"""),

    46 : _("""
 nous traitons les champs de réels et de fonctions: . %(k1)s
"""),

    47 : _("""
 le nom symbolique du champ à chercher n'est pas licite. %(k1)s
"""),

    48 : _("""
 plusieurs instants correspondent à celui spécifié sous AFFE
"""),

    49 : _("""
 NUME_FIN inférieur à NUME_INIT
"""),

    50 : _("""
 CMP non traitée
"""),

    51 : _("""
 Commande CREA_RESU
 La numérotation fournie avec les mots clés MATR_RIGI ou MATR_MASS est différente de celle des champs
 fournis sous le mot clé AFFE.

 Risques & conseils :
 Les champs ont pu être créés par la commande CREA_CHAMP sans préciser la numérotation (mot clé NUME_DDL absent)
"""),

    54 : _("""
  incrément de déformation cumulée (DP) = - %(k1)s
"""),

    55 : _("""
 erreur d'intégration
 - essai d(intégration  numéro  %(k1)s
 - convergence vers une solution non conforme
 - incrément de déformation cumulée négative = - %(k2)s
 - redécoupage du pas de temps
"""),

    56 : _("""
  erreur
  - non convergence à l'itération max  %(k1)s
  - convergence régulière mais trop lente
  - erreur >  %(k2)s
  - redécoupage du pas de temps
"""),

    57 : _("""
  erreur
  - non convergence à l'itération max  %(k1)s
  - convergence irrégulière & erreur >  %(k2)s
  - redécoupage du pas de temps
"""),

    58 : _("""
  erreur
  - non convergence à l'itération max  %(k1)s
  - erreur >  %(k2)s
  - redécoupage du pas de temps
"""),

    59 : _("""
  la transformation géométrique est singulière pour la maille : %(k1)s
  (jacobien = 0.)
"""),

    63 : _("""
 on n'imprime que des champs réels
"""),

    64 : _("""
  %(k1)s CHAM_NO déjà existant
"""),

    65 : _("""
Ce message est un message d'erreur développeur.
Contactez le support technique.
"""),

    79 : _("""
 pas de valeurs propres trouvées
"""),

    80 : _("""
 le champ %(k1)s associé à la grandeur de type %(k2)s ne peut pas être utilisé dans une
 structure de données de type %(k3)s
"""),

    81 : _("""
 L'état initial défini n'est pas plastiquement admissible.
 L'état initial de contraintes est erroné ou les propriétés matériaux ne sont pas adaptées au problème posé.
 Le calcul s'arrête en erreur fatale par précautions.
"""),

}
