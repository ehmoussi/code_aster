# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

    1 : _("""
Redéfinition du DISPLAY vers %(k1)s.
"""),

    2 : _("""
STANLEY fonctionne en mode validation de non régression.
"""),

    3 : _("""
Aucune variable d'environnement DISPLAY définie !
%(k1)s ne pourra pas fonctionner. On l'ignore.

Si vous êtes en Interactif, cochez le bouton Suivi Interactif
dans ASTK.

Vous pouvez également préciser votre DISPLAY dans les arguments
de la commande STANLEY :

STANLEY(DISPLAY='adresse_IP:0.0');
"""),

    4 : _("""
Une erreur est intervenue. Raison : %(k1)s
"""),

    5 : _("""
Cette action n'est pas réalisable: %(k1)s
"""),

    6 : _("""
En mode DISTANT, la variable %(k1)s est obligatoire. On abandonne.
"""),

    7 : _("""
Le paramètre n'est pas renseigné,
Il faut ouvrir le fichier manuellement.
"""),

    8 : _("""
Lancement terminé.
"""),

    9 : _("""
Exécution de %(k1)s
"""),

    10 : _("""
Erreur de lancement de la commande!
"""),

    11 : _("""
Dans le mode WINDOWS, la variable %(k1)s est obligatoire. On abandonne.
"""),

    12 : _("""
Les fichiers de post-traitement sont copiés.
Veuillez maintenant ouvrir manuellement avec GMSH.
"""),

    13 : _("""
Le fichier de post-traitement est copie.
Veuillez maintenant ouvrir manuellement avec GMSH.
"""),

    14 : _("""
Impossible de contacter le serveur SALOME! Vérifier qu'il est bien lancé.
"""),

    15 : _("""
Impossible de récupérer le nom de la machine locale!
Solution alternative : utiliser le mode DISTANT en indiquant l'adresse IP
ou le nom de la machine dans la case 'machine de SALOME'.
"""),

    16 : _("""
Pour visualisation dans SALOME, la variable %(k1)s est obligatoire. On abandonne.
"""),

    17 : _("""
Pour visualisation dans SALOME, la variable machine_SALOME_port est obligatoire.
On abandonne.
"""),

    18 : _("""
Erreur : mode WINDOWS non implémenté
"""),

    19 : _("""
Erreur: il est possible que STANLEY ne puisse pas contacter SALOME :

 - machine SALOME définie : %(k1)s
 - port de SALOME         : %(k2)s
 - lanceur SALOME         : %(k3)s

Vous pouvez modifier ces valeurs dans les paramètres dans STANLEY.

Si STANLEY est bien lancé, vous pouvez essayer d'activer le module VISU.

"""),

    20 : _("""
Exécution terminée.
"""),

    21 : _("""
La session SALOME est inconnue (non disponible dans les arguments).
Le mode GMSH va être activé.
Utilisez le menu si vous souhaitez vous connecter à une session SALOME existante.
 """),

    22 : _("""
Impossible d'affecter la variable [%(k1)s / %(k2)s].
"""),

    23 : _("""
Lecture du fichier d'environnement : %(k1)s
"""),

    24 : _("""
Il n'y a pas de fichier d'environnement.
On démarre avec une configuration par défaut.
"""),

    25 : _("""
Le fichier d'environnement n'a pas la version attendue.
On continue mais en cas de problème, effacer le répertoire ~/%(k1)s et relancer.
"""),

    26 : _("""
Le fichier d'environnement n'est pas exploitable (par exemple c'est une ancienne version).
On démarre avec une configuration par défaut.
"""),

    27 : _("""
On initialise une configuration par défaut.
"""),

    28 : _("""
Nouveaux paramètres sauvegardés dans : %(k1)s
"""),

    29 : _("""
Impossible de sauvegarder les paramètres dans : %(k1)s
"""),

    30 : _("""
Démarrage en mode SALOME sur la machine %(k1)s sur le port %(k2)s.
Remarque : il est nécessaire que cette session soit en cours d'exécution.
"""),

    31 : _("""
Problème : %(k1)s
"""),

    32 : _("""
Impossible d'ouvrir en écriture le fichier %(k1)s
"""),

    33 : _("""
Attention : on ne peut pas tracer un champ aux points de Gauss sur la déformée...
"""),

    34 : _("""
Le champ est tracé avec la déformée.
"""),

    36 : _("""
On ne peut pas tracer une courbe avec une seule abscisse.
"""),

    37 : _("""
Tous les concepts Aster nécessaires à STANLEY n'ont pas été calculés.
Il manque :
%(k1)s
"""),

    38 : _("""
STANLEY - Erreur lors de l'appel à la commande Aster:

%(k1)s
Raison:
%(k2)s
"""),

    40 : _("""
STANLEY - Projection aux points de Gauss: type de résultat non développé
%(k1)s
"""),

}
