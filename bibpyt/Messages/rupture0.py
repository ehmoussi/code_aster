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

cata_msg = {

    1: _("""
Vous avez renseigné le mot clé simple MATER de la commande POST_K1_K2_K3.
Le matériau %(k1)s présent dans la structure de données résultat va être surchargée par le matériau %(k2)s .
"""),

    4: _("""
Erreur utilisateur :
Incohérence entre le mot-clé FISSURE et le modèle associé au mot-clé RESULTAT.
- Pour utiliser une fissure maillée, renseignez sous le mot-clé FOND_FISS
une fissure provenant de la commande DEFI_FOND_FISS.
- Pour utiliser une fissure non maillée (calcul X-FEM), renseignez sous le mot-clé FISSURE
une fissure provenant de la commande DEFI_FISS_XFEM. Le modèle associé au mot-clé RESULTAT
doit être un modèle X-FEM provenant de la commande MODI_MODELE_XFEM.
"""),


    5: _("""
Il faut définir ELAS dans DEFI_MATERIAU.
"""),

    6: _("""
Vous avez renseigné le mot clé simple MATER de la commande POST_K1_K2_K3 avec le matériau %(k1)s qui est un
matériau fonction (ELAS_FO). Ce mot-clé ne peut être renseigné qu'avec un matériau constant (ELAS).
-> Risque et Conseil :
   Veuillez vérifier la définition du matériau %(k1)s.
"""),

    7: _("""
L'entité %(k1)s renseignée au mot-clé %(k2)s n'est pas dans le maillage.
-> Risque et Conseil :
Veuillez vérifier les données fournies au mot-clé %(k2)s.
"""),

    8: _("""
Problème dans la création de la base locale au fond de fissure.
Il est impossible de déterminer le sens de la direction de propagation (vecteur tangent aux lèvres).
Dans le cas symétrique (SYME='OUI') il faut :
- soit donner les lèvres de la fissure (LEVRE_SUP),
- soit indiquer le vecteur tangent au point origine du fond de fissure (DTAN_ORIG).
"""),

    9: _("""
Dans le cas d'une structure de données résultat de type DYNA_TRANS,
le mot-clé EXCIT est obligatoire.
Veuillez le renseigner.
"""),

    11: _("""
Problème à la récupération des noeuds du fond de fissure.
-> Risque et Conseil :
Vérifier que le concept %(k1)s indiqué sous le mot clé FOND_FISS a été
correctement crée par l'opérateur DEFI_FOND_FISS.
"""),

    12: _("""
Type de mailles du fond de fissure non défini.
-> Risque et Conseil :
Pour une modélisation 3D, les mailles de votre fond de fissure
doivent être de type SEG2 ou SEG3.
Veuillez revoir la création de votre fond de fissure
(opérateur DEFI_FOND_FISS).
"""),

    13: _("""
Le GROUP_NO %(k1)s n'est pas dans le maillage.
-> Risque et Conseil :
Veuillez vérifier les données fournies au mot-clé GROUP_NO.
"""),

    15: _("""
Le noeud %(k1)s n'appartient pas au fond de fissure.
-> Risque et Conseil :
Veuillez vérifier les données fournies au mot-clé GROUP_NO ou NOEUD.
"""),

    16: _("""
Les lèvres de la fissure ne sont pas initialement collées.
POST_K1_K2_K3 ne fonctionne que sur des lèvres initialement collées.
-> Risque et Conseil :
   Veuillez vérifier la définition du fond de fissure (DEFI_FOND_FISS/CONFIG_INIT).
   Si les lèvres sont vraiment décollées alors il faut utiliser CALC_G.
"""),

    17: _("""
La différence entre la taille maximale et la taille minimale des mailles connectées aux
noeuds du fond de fissure est importante.
La taille minimale vaut : %(r1)f
La taille maximale vaut : %(r2)f
-> Risque et Conseil :
Il a été choisi de multiplier par %(i1)d la taille maximale des mailles connectées aux
noeuds du fond de fissure pour calculer le paramètre ABSC_CURV_MAXI. Or, si cette taille
est importante, vous risquez de post-traiter vos résultats sur une zone trop éloignée
du fond de fissure et d'obtenir des valeurs de facteurs d'intensité moins précises.
Vérifiez que la valeur de ABSC_CURV_MAXI calculée est licite.
Sinon, veuillez spécifier directement la valeur de ABSC_CURV_MAXI ou bien revoir
le maillage de manière à rendre les mailles proches du fond de fissure de taille homogène.
"""),

    18: _("""
Problème à la récupération du modèle dans la structure de données résultat fournie.
-> Risque et Conseil :
Veuillez vérifier que le concept fourni au mot-clé RESULTAT correspond
au résultat à considérer.
"""),

    19: _("""
Problème à la récupération des noeuds de la lèvre supérieure :
-> Risque et Conseil :
Pour un calcul avec POST_K1_K2_K3, la lèvre supérieure de la fissure doit
être obligatoirement définie dans DEFI_FOND_FISS à l'aide du mot-clé
LEVRE_SUP. Vérifier la définition du fond de fissure.
"""),

    21: _("""
Les noeuds ne sont pas en vis-à-vis dans le plan perpendiculaire
au noeud %(k1)s.
-> Risque et Conseil :
Pour interpoler les sauts de déplacement, les noeuds doivent être par défaut
en vis-à-vis deux à deux sur les lèvres. Si ce n'est pas le cas, utilisez
l'option TYPE_MAILLE='LIBRE' dans POST_K1_K2_K3.
"""),

    22: _("""
Il manque des points dans le plan défini par la lèvre
supérieure et perpendiculaire au fond %(k1)s.
-> Risque et Conseil :
"""),

    23: _("""
Vérifier les tangentes extrémités ou
"""),

    24: _("""
Augmenter PREC_NORM dans DEFI_FOND_FISS.
"""),

    25: _("""
Augmenter ABSC_CURV_MAXI.
"""),

    26: _("""
Il manque des points dans le plan défini par la lèvre
inférieure et perpendiculaire au fond  %(k1)s.
-> Risque et Conseil :
"""),

    27: _("""
Pour un résultat de type MODE_MECA, seule l'option CALC_K_G est disponible.
"""),

    29: _("""
Lorsque une modélisation 3D est de type FEM l'option %(k1)s nécessite une
fissure en configuration collée.
-> Risque et Conseil :
Veuillez mettre CONFIG_INIT='COLLEE' dans DEFI_FOND_FISS.
"""),

    30: _("""
Calcul possible pour aucun noeud du fond.
-> Risque et Conseil :
Veuillez vérifier les données, notamment celles du mot-clé DIRECTION.
"""),

    31: _("""
Il n'y a pas de mailles de bord connectées au noeud %(k1)s.
"""),

    32: _("""
Le paramètre ABSC_CURV_MAXI automatiquement choisi vaut : %(r1)f.
"""),

    33: _("""
Le front de fissure contient plus qu'un noeud en 2D. La fissure est mal définie.
-> Risque et Conseil :
Vérifiez les données d'entrée de la fissure dans DEFI_FOND_FISS, CALC_G ou CALC_THETA.
"""),

    34: _("""
L'hypothèse de lèvres collées n'est pas valide.
Cela peut être dû au fait :
 - que seule la lèvre supérieure est modélisée. Dans ce cas, il faut mettre SYME='OUI'.
 - que les lèvres sont initialement décollées. Dans ce cas, il faut mettre CONFIG_INIT='DECOLLEE'.
"""),

    35: _("""
Attention, le vecteur tangent au premier noeud du fond de fissure (DTAN_ORIG) est dans le sens
opposé à celui calculé automatiquement (%(r1)f %(r2)f %(r3)f).
Cela est probablement une erreur, qui peut conduire à des résultats faux.
-> Risque et Conseil :
  - vérifiez DTAN_ORIG,
  - ou bien ne le renseignez pas.
"""),

    36: _("""
Attention, le vecteur tangent au dernier noeud du fond de fissure (DTAN_EXTR) est dans le sens
opposé à celui calculé automatiquement (%(r1)f %(r2)f %(r3)f).
Cela est probablement une erreur, qui peut conduire à des résultats faux.
-> Risque et Conseil :
  - vérifiez DTAN_EXTR,
  - ou bien ne le renseignez pas.
"""),

    37: _("""
Le numéro d'ordre %(i1)d n'a pas été trouvé dans la table.
"""),

    38: _("""
Pas d'instant trouvé dans la table pour l'instant %(r1)f.
"""),

    39: _("""
Plusieurs instants trouvés dans la table pour l'instant %(r1)f.
"""),

    40: _("""
La dimension de la modélisation (%(i1)dD) est différente de celle des éléments en front de fissure (%(i2)dD).
-> Risque :
Il est possible que vous ayez utilisé des éléments de structure. Ces éléments ne sont pas compatibles avec les opérateurs de mécanique de la rupture.
-> Conseil :
Utilisez les modélisations compatibles : 3D, D_PLAN (2D), C_PLAN (2D) ou AXIS (2D).
"""),

    41 : _("""
Le groupe de mailles %(k1)s défini sous le mot-clé GROUP_MA n'existe pas.
"""),

    42 : _("""
Dans le cas où le fond est une courbe fermée, les mots-clés MAILLE_ORIG ou GROUP_MA_ORIG doivent accompagner le mot-clé NOEUD_ORIG ou GROUP_NO_ORIG.
"""),

    43 : _("""
Le noeud défini le mot-clé NOEUD_ORIG ou GROUP_NO_ORIG n'appartient pas à la maille définie
sous le mot-clé MAILLE_ORIG ou GROUP_MA_ORIG.
"""),

    44 : _("""
La maille %(k1)s définie sous le mot-clé MAILLE_ORIG ou GROUP_MA_ORIG n'appartient pas au fond de fissure.
"""),

    45 : _("""
Une seule maille doit constitué le groupe de mailles GROUP_MA_ORIG. La maille utilisée est %(k1)s.
"""),

    46: _("""
Il faut au moins trois noeuds dans le plan défini par les lèvres et perpendiculaire
au fond de fissure. Le calcul est impossible. On extrapole les valeurs du point le plus proche.
"""),

    47: _("""
Noeud %(k1)s
"""),

    49: _("""
Le maillage ne permet pas de déterminer la taille des mailles en fond de fissure, et donc
R_INF/R_SUP ou ABSC_CURV_MAXI seront obligatoires en post-traitement.
-> Conseil :
Pour ne plus avoir cette alarme, il faut revoir le maillage et faire en sorte que chaque noeud du fond
de fissure soit connecté à au moins une arête faisant un angle inférieur à 60 degrés avec le vecteur de
direction de propagation.
"""),

    50: _("""
Nombre de modes différent entre la base modale
et %(k1)s : on prend le minimum des deux %(i1)d.
"""),

    51: _("""
Le numéro d'ordre %(i1)d n'appartient pas au résultat %(k1)s.
"""),

    53: _("""
Vous avez utilisé un module de Young nul. Le post-traitement ne peut pas se poursuivre."""),

    54: _("""
Aucun instant ou numéro d'ordre trouvé.
"""),

    55: _("""
-> Attention: Le mot-clé EXCIT est facultatif, il n'est pas nécessaire dans tous les cas.
Il n'est utile que si le résultat à post-traiter a été créé avec la commande CREA_RESU.
-> Risque et Conseil :
Si vous utilisez CALC_G en dehors de ce cas spécifique,
vérifiez la présence de tous les chargements ayant servi à créer le résultat.
"""),

    56 : _("""
CALC_G - option CALC_K_G : le calcul est impossible sur un point de rayon nul
(point sur l'axe de rotation).
-> Risque et Conseil :
Modifier les couronnes R_INF et R_SUP pour qu'elles soient toutes les deux plus
petites que le rayon du fond de fissure. De manière générale en axisymétrie, le
calcul de K est d'autant plus précis que le rayon des couronnes est petit devant
le rayon du fond de fissure.
"""),

    57 : _("""
Pour cette option en 3D, le champ THETA doit être calculé directement
dans l'opérateur CALC_G.
-> Risque et Conseil :
Dans le mot-clé facteur THETA, supprimez le mot-clé THETA et renseignez les
mots-clés FOND_FISS, R_SUP, R_INF, MODULE, et DIRECTION pour la détermination
automatique du champ thêta.
"""),

    58: _("""
Le mot clef DIRECTION n'a pas été renseigné et la fissure n'a pas été définie dans DEFI_FOND FISS.
-> Risque et Conseil :
Définissez la fissure dans DEFI_FOND_FISS ou renseignez le mot clef DIRECTION.
"""),

    60 : _("""
Mélange de mailles de type SEG2 et SEG3 dans la définition du fond de fissure.
-> Risque et Conseil :
Les mailles du fond de fissure doivent toutes être du même type.
Modifiez le maillage ou définissez plusieurs fonds de fissure consécutifs.
"""),

    61 : _("""
L'angle entre 2 vecteurs normaux consécutifs est supérieur à 10 degrés.
Cela signifie que la fissure est fortement non plane.
-> Risque et Conseil :
 - Le calcul des facteurs d'intensité des contraintes sera potentiellement imprécis,
 - Un raffinement du fond de fissure est probablement nécessaire.
"""),

    63 : _("""
Les mailles du fond de fissure doivent être du type segment (SEG2 ou SEG3).
"""),

    65 : _("""
Détection d'une maille de type %(k1)s dans la définition des lèvres de la
fissure (%(k2)s).
-> Risque et Conseil :
Les mailles des lèvres doivent être du type quadrangle ou triangle.
Vérifiez que les mailles définies correspondent bien aux faces des éléments
3D qui s'appuient sur la lèvre.
"""),

    66 : _("""
Le groupe de noeuds ou la liste de noeuds définissant le fond de fissure n'est pas ordonné.
-> Risque et Conseil :
Il faut ordonner les noeuds du fond de fissure.
Les options SEGM_DROI_ORDO et NOEUD_ORDO de l'opérateur
DEFI_GROUP/CREA_GROUP_NO peuvent être utilisées.
."""),

    70 : _("""
Erreur utilisateur : la lèvre définie sous %(k1)s possède une maille répétée 2 fois :
maille %(k2)s.
-> Risque et Conseil :
Veuillez revoir les données.
"""),


    72 : _("""
Le noeud %(k1)s du fond de fissure n'est rattaché à aucune maille surfacique
de la lèvre définie sous %(k2)s.
-> Risque et Conseil :
Veuillez vérifier les groupes de mailles.
"""),

    73 : _("""
Erreur utilisateur : la lèvre inférieure et la lèvre supérieure ont une maille
surfacique en commun. Maille en commun : %(k1)s
-> Risque et Conseil :
Revoir les données.
"""),

    74: _("""
Le mode %(i1)d n'a pas été trouvé dans la table.
"""),

    75 : _("""
Détection d'une maille de type %(k1)s dans la définition des lèvres de la
fissure (%(k2)s).
-> Risque et Conseil :
Les mailles des lèvres doivent être linéiques. Vérifiez que les mailles
définies correspondent bien aux faces des éléments 2D qui s'appuient
sur la lèvre.
"""),

    76: _("""
Erreur utilisateur.
Cette combinaison de lissage est interdite avec X-FEM.
"""),

    78: _("""
La tangente à l'origine n'est pas orthogonale à la normale :
   Normale aux lèvres de la fissure : %(r1)f %(r2)f %(r3)f
   Tangente à l'origine (= direction de propagation) :  %(r4)f %(r5)f %(r6)f
-> Risque et Conseil :
La tangente à l'origine est nécessairement dans le plan de la fissure,
donc orthogonale à la normale fournie. Vérifier les données.
"""),

    79: _("""
La tangente à l'extrémité n'est pas orthogonale à la normale :
   Normale aux lèvres de la fissure : %(r1)f %(r2)f %(r3)f
   Tangente à l'origine (= direction de propagation) :  %(r4)f %(r5)f %(r6)f
-> Risque et Conseil :
La tangente à l'extrémité est nécessairement dans le plan de la fissure,
donc orthogonale à la normale fournie. Vérifier les données.
"""),

    84: _("""
Le degré des polynômes de Legendre doit être inférieur au nombre de noeuds
du fond de fissure (ici égal à %(i1)i) lorsque le lissage de G est de type
LEGENDRE et le lissage de THETA de type LAGRANGE.
"""),

    86: _("""
Erreur utilisateur.
Cette combinaison de lissage est interdite.
"""),

    88: _("""
Aucune fréquence trouvée dans la table pour la fréquence %(r1)f.
"""),

    89: _("""
Plusieurs fréquences trouvées dans la table pour la fréquence %(r1)f.
"""),



    90: _("""
L'usage des polynômes de Legendre dans le cas d'un fond de fissure clos
est interdit.
-> Risque et Conseil :
Veuillez redéfinir le mot-clé LISSAGE_THETA.
"""),

    92: _("""
Incohérence entre la dimension du maillage et le nombre de noeuds du fond. L'opérateur
DEFI_FOND_FISS ne trouve qu'un seul noeud pour le fond, mais le maillage %(k1)s est considéré
comme tridimensionnel.
-> Risque et Conseil :
S'il s'agit d'un maillage 2d, les noeuds doivent obligatoirement se situer dans le plan z=0.
"""),

    93: _("""
Accès impossible au champ SIEF_ELGA pour le numéro d'ordre : %(i1)d.
Or il est nécessaire de connaître SIEF_ELGA car vous avez activé le mot-clé
CALCUL_CONTRAINTE='NON'. Le calcul s'arrête.
-> Conseils :
- Vérifiez vote mise en données pour archiver SIEF_ELGA à tous les instants
demandés dans la commande CALC_G.
- Ou bien supprimer CALCUL_CONTRAINTE='NON' de la commande CALC_G.
"""),

    95: _("""
Erreur utilisateur.
Il y a incompatibilité entre le mot-clé FOND_FISS et le modèle %(k1)s associé
à la structure de données résultat. En effet, le modèle %(k1)s est un modèle X-FEM.
-> Conseil :
Lorsque le modèle est de type X-FEM il faut obligatoirement utiliser
le mot-clé FISSURE de la commande CALC_G.
"""),

    96: _("""
Erreur utilisateur.
Il y a incompatibilité entre le mot-clé FISSURE et le modèle %(k1)s associé
à la structure de données résultat. En effet, le modèle %(k1)s est un modèle non X-FEM.
-> Conseil :
Veuillez utiliser les mots-clés FOND_FISS ou THETA ou revoir votre modèle.
"""),

    97: _("""
Erreur utilisateur.
Il y a incompatibilité entre le mot-clé FISSURE et le modèle %(k2)s associé
à la structure de données résultat. En effet, la fissure %(k1)s n'est pas associée au
modèle %(k2)s.
-> Conseils :
  - Vérifier le mot-clé FISSURE,
  - Vérifier le mot-clé RESULTAT,
  - Vérifier la commande MODI_MODELE_XFEM qui a créé le modèle %(k2)s.
"""),

    98: _("""
Erreur dans l'utilisation du mot clé facteur FOND_FISS.
Dans le cas d'un fond fermé, il n'est pas possible d'utiliser le mot clé simple GROUP_NO.
Vous devez obligatoirement utiliser le mot clé simple GROUP_MA.
"""),

    99: _("""
Point du fond numéro : %(i1)d.
Augmenter NB_NOEUD_COUPE. S'il s'agit d'un noeud extrémité, vérifier les tangentes
(DTAN_ORIG et DTAN_EXTR).
"""),

}
