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

    1  : _("""
Avec un schéma de type explicite, seule la prédiction TANGENTE est possible
"""),

    2 : _("""
A cause des erreurs précédentes, le code s'arrête.
  Vous voulez "poursuivre" un calcul non-linéaire (STAT_NON_LINE ou DYNA_NON_LINE).
  Pour cela, vous précisez un état initial (mot clé ETAT_INIT).
  Pour le calcul du premier pas de temps, le champ des variables internes du début du pas est pris
  dans le concept EVOL_NOLI fourni ou par le champ VARI_ELGA.
  On l'a comparé avec le champ des variables internes créé par le mot-clef COMPORTEMENT, il y a incohérence.
  Vérifiez la cohérence entre le comportement et le champ des variables internes donné dans l'état initial.
"""),


    3 : _("""
 Il n'est pas possible actuellement de calculer des modes de flambement
 (CRIT_FLAMB) ou des modes vibratoires (MODE_VIBR) si on utilise la
 méthode continue du contact ou XFEM avec du contact.
"""),


    4 : _("""
 Vous utilisez une méthode de contact (continue ou XFEM) qui nécessite de réactualiser la matrice tangente
 à chaque itération. La réactualisation est donc forcée (REAC_ITER = 1).

  -> Risque & Conseil :
   - Vous pouvez supprimer cette alarme si vous
     renseignez REAC_ITER=1 sous le mot-clé facteur NEWTON.

"""),

    5 : _("""
 Vous utilisez une méthode de contact (contact discret ou unilatéral avec pénalisation ou élément DIS_CHOC)
  qui apporte une contribution à la matrice tangente à chaque itération. La réactualisation est donc forcée (REAC_ITER=1) et ce même si vous utilisez la matrice
 'ELASTIQUE'.

  -> Risque & Conseil :
   - Vous pouvez supprimer cette alarme dans le cas où vous utilisez une matrice 'TANGENTE', pour cela
     renseignez REAC_ITER=1 sous le mot-clé facteur NEWTON.
"""),

    6 : _("""
 Le calcul des énergies n'est pas disponible avec le mot-clé PROJ_MODAL.
"""),

    7 : _("""
 Étant donné la présence du mot clé AMOR_ALPHA et / ou AMOR_BETA,
 on va assembler la matrice d'amortissement globale de Rayleigh,
 même si ces coefficients sont tous les deux nuls.
 Cette opération engendre un surcoût de calcul.
"""),

    8 : _("""
 Le calcul des énergies n'est pas disponible lorsque MATR_DISTRIBUEE='OUI'.
"""),

    9 : _("""
 Pour avoir BETA nul (schéma purement explicite) avec un schéma de Newmark (standard ou HHT),
utilisez DIFF_CENT ou TCHAMWA.
"""),

    10 : _("""
 Pour un schéma purement explicite (DIFF_CENT ou TCHAMWA), seule la formulation
en accélération est possible
"""),

    11 : _("""
 Pour un schéma de type NEWMARK, seules les formulations en accélération et en déplacement sont possibles
"""),

    13 : _("""
 La matrice de masse diagonale (option MASS_DIAG) n'est pas utilisable avec un schéma implicite.
"""),

    14 : _("""
 Il n'est pas possible actuellement de calculer des modes de flambement
 (CRIT_FLAMB) ou des modes vibratoires (MODE_VIBR) si on utilise la
 méthode discrète du contact avec frottement ou la méthode pénalisée.
"""),

    15 : _("""
 Le calcul des énergies n'est pas disponible avec le contact en formulation continue ou XFEM.
"""),

    16 : _("""
 Les modélisations de type THMS sont interdites en dynamique.
"""),

    19 : _("""
Il y a plus d'amortissements modaux (AMOR_MODAL) que de modes.
"""),

    20 : _("""
On ne trouve pas le champ de déplacement pour Dirichlet différentiel dans le concept <%(k1)s>.
Votre valeur de NUME_DIDI doit être incorrecte ou le concept n'est pas le bon.

"""),

    21 : _("""
  -> Critère de convergence est lâche !
  -> Risque & Conseil : La valeur de RESI_GLOB_RELA est supérieure à 10-4.
     Cela peut nuire à la qualité de la solution. Vous ne vérifiez pas l'équilibre de
     manière rigoureuse.
"""),

    22 : _("""
Schéma en dynamique explicite.
Le contact n'est pas possible.
"""),

    23 : _("""
Schéma en dynamique explicite.
Les liaisons unilatérales ne sont pas possibles.
"""),

    24 : _("""
Schéma en dynamique explicite.
Les poutres en grandes rotations POU_D_T_GD et POU_D_TGM ne sont utilisables
qu'en faibles rotations.
"""),

    25 : _("""
Dynamique non-linéaire
Le pilotage n'est pas possible.
"""),

    28 : _("""
Dynamique non-linéaire
La méthode XFEM n'est pas possible.
"""),


    29 : _("""
Vous faites de la projection modale PROJ_MODAL en explicite.
Il y a %(i1)d  modes dans la structure MODE_MECA.
Le nombre de modes (mot-clef NB_MODE dans PROJ_MODAL) vaut %(i2)d.
On prend donc %(i3)d modes.
"""),

    30 : _("""
Vous faites de l'amortissement modal (réduit ou non).
Il y a %(i1)d  modes dans la structure MODE_MECA.
Le nombre de modes (mot-clef NB_MODE dans AMOR_MODAL) vaut %(i2)d.
On prend donc %(i3)d modes.
"""),

    31 : _("""
Vous faites de la projection modale PROJ_MODAL en explicite en reprise.
Il n'y a pas de modes stockés lors du calcul précédent.
On part donc de DEPL/VITE/ACCE généralisés nuls.
"""),




    33 : _("""
Dynamique non-linéaire
La méthode IMPLEX n'est pas possible.
"""),

    34 : _("""
La recherche linéaire est incompatible avec le pilotage de type DDL_IMPO.
"""),

    35 : _("""
La recherche linéaire de type PILOTAGE nécessite de faire du pilotage (présence du mot-clef facteur PILOTAGE).
"""),

    36 : _("""
La prédiction de type EXTRAPOL ou DEPL_CALCULE est incompatible avec le pilotage.
"""),

    37 : _("""
L'usage de ARRET='NON' dans CONVERGENCE est dangereux et doit être utilisé avec précaution car il permet à un calcul de converger
même lorsque l'équilibre n'est pas vérifié.
"""),

    39 : _("""
La recherche linéaire est incompatible avec des chargements de Dirichlet de type suiveur.
"""),

    40 : _("""
La dynamique avec des chargements de Dirichlet de type suiveur.
"""),

    41 : _("""
Les chargements de Dirichlet de type suiveur impliquent la réactualisation de la matrice REAC_ITER=1.
"""),

    42 : _("""
Le pilotage est incompatible avec des chargements de Dirichlet de type suiveur.
"""),
    43 : _("""
  -> Les paramètres RHO_MIN et RHO_MAX sont identiques.
"""),
    44 : _("""
  -> La définition des paramètres RHO_MIN et RHO_MAX est contradictoire.
     On choisit de prendre RHO_MIN plus petit que RHO_MAX.
"""),


    45 : _("""
Il faut préciser un concept EVOL_NOLI en prédiction de type 'DEPL_CALCULE'
"""),

    46 : _("""
  -> La définition des paramètres RHO_MIN et RHO_EXCL est contradictoire.
     On choisit de prendre RHO_MIN à RHO_EXCL.
  -> Risque & Conseil :
     RHO_MIN ne doit pas être compris entre -RHO_EXCL et RHO_EXCL

"""),

    47 : _("""
  -> La définition des paramètres RHO_MAX et RHO_EXCL est contradictoire.
     On choisit de prendre RHO_MAX à -RHO_EXCL.
  -> Risque & Conseil :
     RHO_MAX ne doit pas être compris entre -RHO_EXCL et RHO_EXCL

"""),

    48 : _("""
  Le pilotage est incompatible avec la méthode NEWTON_KRYLOV.
"""),


    50 : _("""
 Pilotage.
 La composante <%(k1)s> n'a pas été trouvée dans la numérotation.
 Vérifier NOM_CMP dans le mot-clef PILOTAGE.
"""),

    51 : _("""
 Pour utiliser METHODE='NEWTON_KRYLOV', il faut utiliser une méthode itérative (GCPC, PETSC) sous le mot-clé SOLVEUR.
"""),

    52 : _("""
Il n'y a aucun degré de liberté de déplacement sur le modèle.
"""),

    53: _("""
   Le critère RESI_COMP_RELA est interdit en dynamique. Utilisez un autre critère de convergence
"""),

    54 : _("""L'usage de ARRET='NON' avec le contact implique d'utiliser REAC_GEOM = 'SANS'"""),

    55 : _("""
  Vous utilisez l'indicateur de convergence RESI_REFE_RELA et une modélisation %(k1)s.
  Vous devez renseigner la valeur de référence %(k2)s dans CONVERGENCE.
"""),

    56 : _("""
  Il n'est pas possible actuellement de calculer des modes vibratoires (MODE_VIBR)
  sur un modèle dont au moins une matrice assemblée (masse ou raideur) est non-symétrique.
"""),

    57 : _("""
De manière générale, PREDICTION = 'DEPL_CALCULE' est là pour éviter de devoir factoriser une matrice et gagner en temps de calcul.
Mais les limitations (problèmes de conditions limites) font que cette fonctionnalité n'est pas à recommander et qu'on lui préférera par exemple un PREDICTION='ELASTIQUE'.
"""),

    58 : _("""
A cause des erreurs précédentes, le code s'arrête.
  Vous voulez "poursuivre" un calcul non-linéaire (STAT_NON_LINE ou DYNA_NON_LINE).
  Pour cela, vous précisez un état initial (mot clé ETAT_INIT).
  Pour le calcul du premier pas de temps, le champ des contraintes du début du pas est pris
  dans le concept EVOL_NOLI fourni ou par le champ SIGM.
  On a comparé son nombre des sous-points avec celui correspondant au mot-clef COMPORTEMENT,
  il y a incohérence.
"""),

    60 : _("""La formulation HHO est incompatible avec le contact."""),

    61 : _("""La formulation HHO est incompatible avec les liaisons unilatérales."""),

    62 : _("""La formulation HHO est incompatible avec le pilotage."""),

    63 : _("""La formulation HHO est incompatible avec la recherche linéaire."""),

    64 : _("""La formulation HHO est incompatible avec la dynamique."""),

    65 : _("""La formulation HHO est incompatible avec la réduction de modèle."""),

    66 : _("""La formulation HHO est incompatible avec XFEM."""),

    67 : _("""La formulation HHO est incompatible avec les macro-éléments."""),

    68 : _(""" Il n'est pas possible actuellement de calculer des modes de flambement (CRIT_FLAMB) ou des modes vibratoires (MODE_VIBR) si on utilise la formulation HHO."""),

    69 : _("""La formulation HHO est incompatible avec les chargements suiveurs."""),

    70 : _("""La formulation HHO est incompatible avec ETAT_INIT."""),

    71 : _("""La formulation HHO est incompatible en reprise de calcul."""),


}
